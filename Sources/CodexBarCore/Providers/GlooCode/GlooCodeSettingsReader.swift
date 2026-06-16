import Foundation

public enum GlooCodeSettingsReader {
    public static let apiKeyEnvironmentKey = "GLOOCODE_API_KEY"
    public static let apiURLEnvironmentKey = "GLOOCODE_API_URL"
    public static let projectIDEnvironmentKey = "GLOOCODE_PROJECT_ID"
    public static let defaultAPIURL = URL(string: "https://api.gloocode.ai/v1")!

    public static func apiKey(
        environment: [String: String] = ProcessInfo.processInfo.environment) -> String?
    {
        self.cleaned(environment[self.apiKeyEnvironmentKey])
    }

    public static func apiURL(
        environment: [String: String] = ProcessInfo.processInfo.environment) throws -> URL
    {
        guard let raw = self.cleaned(environment[self.apiURLEnvironmentKey]) else {
            return self.defaultAPIURL
        }
        guard let url = ProviderEndpointOverrideValidator.normalizedHTTPSURL(from: raw) else {
            throw GlooCodeSettingsError.invalidEndpointOverride(self.apiURLEnvironmentKey)
        }
        return url
    }

    public static func projectID(
        environment: [String: String] = ProcessInfo.processInfo.environment) -> String?
    {
        self.cleaned(environment[self.projectIDEnvironmentKey])
    }

    static func cleaned(_ raw: String?) -> String? {
        guard var value = raw?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
            return nil
        }

        if (value.hasPrefix("\"") && value.hasSuffix("\"")) ||
            (value.hasPrefix("'") && value.hasSuffix("'"))
        {
            value = String(value.dropFirst().dropLast())
        }

        value = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}

public enum GlooCodeSettingsError: LocalizedError, Sendable, Equatable {
    case missingToken
    case invalidEndpointOverride(String)

    public var errorDescription: String? {
        switch self {
        case .missingToken:
            "GlooCode API key not configured. Set GLOOCODE_API_KEY or configure a token in Settings."
        case let .invalidEndpointOverride(key):
            "GlooCode endpoint override \(key) must use HTTPS or a bare host."
        }
    }
}
