require "honeycomb-beeline"

Honeycomb.configure do |config|
  config.write_key = ENV.fetch("HONEYCOMB_WRITE_KEY")
  config.service_name = "jobs-search"
  config.dataset = ENV.fetch("HONEYCOMB_DATASET")
end

module WrapInSpan
  def self.new(method_name, name: nil)
    Module.new do
      define_method method_name do |*args, **kwargs, &block|
        span_name = name || "#{self.class.name}##{method_name}"
        Tracing.start_span(span_name) do
          super(*args, **kwargs, &block)
        end
      end
    end
  end
end

module Tracing
  def self.record_exception(exception)
    active_span.add_field("error", exception.message)
    active_span.add_field("error_detail", exception.backtrace.join("\n"))
  end

  def self.start_span(name, parent: nil, **fields, &)
    serialized_trace = parent&.to_trace_header
    Honeycomb.start_span(name: name, serialized_trace:, **fields, &)
  end

  def self.active_span
    Honeycomb.current_span
  end

  module ClassMethods
    def span(method_name)
      prepend WrapInSpan.new(method_name)
    end

    def class_span(method_name)
      class_eval do
        prepend WrapInSpan.new(method_name, name: "#{name}.#{method_name}")
      end
    end

    def active_span
      Tracing.active_span
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def active_span
    Tracing.active_span
  end
end