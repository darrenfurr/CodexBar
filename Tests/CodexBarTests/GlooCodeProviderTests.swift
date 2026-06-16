import Foundation
import Testing
@testable import CodexBarCore

@Suite(.serialized)
struct GlooCodeProviderTests {
    @Test
    func `settings reader cleans api key and resolves default base url`() throws {
        let environment: [String: String] = [
            GlooCodeSettingsReader.apiKeyEnvironmentKey: "  'gloo-key-123'  ",
        ]

        #expect(GlooCodeSettingsReader.apiKey(environment: environment) == "gloo-key-123")
        #expect(try GlooCodeSettingsReader.apiURL(environment: [:]) == GlooCodeSettingsReader.defaultAPIURL)
    }

    @Test
    func `settings reader accepts explicit https api url override`() throws {
        let environment: [String: String] = [
            GlooCodeSettingsReader.apiURLEnvironmentKey: "https://gloo.example.com/v1",
        ]

        #expect(try GlooCodeSettingsReader.apiURL(environment: environment) == URL(string: "https://gloo.example.com/v1"))
    }

    @Test
    func `provider descriptor is wired to gloocode`() {
        let descriptor = GlooCodeProviderDescriptor.descriptor

        #expect(descriptor.id == .gloocode)
        #expect(descriptor.metadata.displayName == "GlooCode")
        #expect(descriptor.metadata.cliName == "gloocode")
        #expect(descriptor.metadata.toggleTitle == "Show GlooCode usage")
    }
}
