class ProconBypassMan::ReportProconPerformanceMeasurementsJob < ProconBypassMan::BaseJob
  extend ProconBypassMan::HasExternalApiSetting

  # @param [String] body
  def self.perform(body)
    measurement_collection = ProconBypassMan::Procon::PerformanceMeasurement.pop_measurement_collection
    metrics = ProconBypassMan::Procon::PerformanceMeasurement.summarize(measurements: measurement_collection.measurements)
    body = {
      timestamp_key: timestamp_key,
      time_taken_max:metrics.time_taken_max,
      time_taken_p99: metrics.time_taken_p50,
      time_taken_p99: metrics.time_taken_p99,
      time_taken_p95: metrics.time_taken_p95,
      read_error_count: metrics.read_error_count,
      write_error_count: metrics.write_error_count,
    }

    ProconBypassMan::ReportHttpClient.new(
      path: path,
      server_pool: server_pool,
    ).post(body: body)
  end

  def self.path
    '/'
  end
end
