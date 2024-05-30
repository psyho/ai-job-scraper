require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
require 'opentelemetry/instrumentation/all'

OpenTelemetry::SDK.configure do |c|
  c.use_all
end

TRACER = OpenTelemetry.tracer_provider.tracer('job-search')

at_exit do
  OpenTelemetry.tracer_provider.shutdown
end

module WrapInSpan
  def self.new(method_name, name: nil)
    Module.new do
      define_method method_name do |*args, **kwargs, &block|
        span_name = name || "#{self.class.name}##{method_name}"
        TRACER.in_span(span_name) do
          super(*args, **kwargs, &block)
        end
      end
    end
  end
end

module Tracing
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
      OpenTelemetry::Trace.current_span
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def active_span
    OpenTelemetry::Trace.current_span
  end
end