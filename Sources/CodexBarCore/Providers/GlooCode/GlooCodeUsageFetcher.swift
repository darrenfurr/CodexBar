import Foundation

public enum GlooCodeUsageFetcher {
    public static func fetchUsage(
        apiKey: String,
        environment: [String: String] = ProcessInfo.processInfo.environment,
        historyDays: Int = 30) async throws -> OpenAIAPIUsageSnapshot
    {
        let apiURL = try GlooCodeSettingsReader.apiURL(environment: environment)
        let costsURL = apiURL.appendingPathComponent("organization/costs")
        let completionsURL = apiURL.appendingPathComponent("organization/usage/completions")
        return try await OpenAIAPIUsageFetcher.fetchUsage(
            apiKey: apiKey,
            projectID: GlooCodeSettingsReader.projectID(environment: environment),
            costsURL: costsURL,
            completionsURL: completionsURL,
            historyDays: historyDays)
    }
}
