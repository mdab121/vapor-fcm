@testable import Vapor
@testable import VaporFCM

func makeTestDroplet() throws -> Droplet {
	let drop = Droplet(arguments: ["dummy/path/", "prepare"], environment: Environment.test)
	try drop.runCommands()
	return drop
}
