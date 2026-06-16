import CodexBarCore
import Foundation

struct GlooCodeProviderImplementation: ProviderImplementation {
    let id: UsageProvider = .gloocode

    @MainActor
    func presentation(context _: ProviderPresentationContext) -> ProviderPresentation {
        ProviderPresentation { _ in "api" }
    }

    @MainActor
    func isAvailable(context: ProviderAvailabilityContext) -> Bool {
        GlooCodeSettingsReader.apiKey(environment: context.environment) != nil
    }
}
