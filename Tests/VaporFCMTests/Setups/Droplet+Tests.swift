@testable import Vapor
@testable import VaporFCM

func makeTestDroplet() throws -> Droplet {
	let config = try! Config(prioritized: [], arguments: ["dummy/path/", "prepare"], environment: .test)
	let drop = try! Droplet(config)
	return drop
}
