import Foundation

public enum GlooCodeProviderDescriptor {
    public static let descriptor: ProviderDescriptor = Self.makeDescriptor()

    static func makeDescriptor() -> ProviderDescriptor {
        ProviderDescriptor(
            id: .gloocode,
            metadata: ProviderMetadata(
                id: .gloocode,
                displayName: "GlooCode",
                sessionLabel: "Spend",
                weeklyLabel: "Usage",
                opusLabel: nil,
                supportsOpus: false,
                supportsCredits: false,
                creditsHint: "Usage is sourced from the GlooCode API.",
                toggleTitle: "Show GlooCode usage",
                cliName: "gloocode",
                defaultEnabled: false,
                isPrimaryProvider: false,
                usesAccountFallback: false,
                dashboardURL: nil,
                statusPageURL: nil),
            branding: ProviderBranding(
                iconStyle: .codex,
                iconResourceName: "ProviderIcon-codex",
                color: ProviderColor(red: 0.15, green: 0.57, blue: 0.91)),
            tokenCost: ProviderTokenCostConfig(
                supportsTokenCost: true,
                noDataMessage: { "GlooCode usage needs an API key." }),
            fetchPlan: .apiToken(
                strategyID: "gloocode.api",
                resolveToken: { GlooCodeSettingsReader.apiKey(environment: $0) },
                missingCredentialsError: { GlooCodeSettingsError.missingToken },
                loadUsage: { apiKey, context in
                    try await GlooCodeUsageFetcher.fetchUsage(
                        apiKey: apiKey,
                        environment: context.env).toUsageSnapshot()
                }),
            cli: ProviderCLIConfig(
                name: "gloocode",
                aliases: ["gloo-code"],
                versionDetector: nil))
    }
}
