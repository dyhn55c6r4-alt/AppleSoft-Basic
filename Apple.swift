#!/usr/bin/env swift
import Foundation

// MARK: - Locate Apple.ASM inside the MacOS sandbox

let cwd = FileManager.default.currentDirectoryPath
let sourceFile = "\(cwd)/Apple.ASM"

// MARK: - Replace external tools with your Swift pipeline

// These commands CANNOT point to real executables on MacOS.
// Instead, they become symbolic placeholders that your Swift code handles.

let assembleCommand: [String] = [
	"swift-assembler",  // symbolic name
	sourceFile,
	"-o", "\(cwd)/Apple.o"
]

let runCommand: [String] = [
	"swift-runner",  // symbolic name
	"\(cwd)/Apple.o",
	"-o", "\(cwd)/Apple.bin"
]

// MARK: - Process helper (still valid)

@discardableResult
func runProcess(_ command: [String]) throws -> Int32 {
	guard let executable = command.first else {
		throw NSError(
			domain: "SwiftRunner", code: 1,
			userInfo: [NSLocalizedDescriptionKey: "Empty command"])
	}

	print("→ \(executable) \(command.dropFirst().joined(separator: " "))")

	// Instead of running a real process, dispatch to Swift functions
	switch executable {
	case "swift-assembler":
		return assembleSwiftASM(args: Array(command.dropFirst()))
	case "swift-runner":
		return runSwiftBinary(args: Array(command.dropFirst()))
	default:
		print("Unknown command: \(executable)")
		return 1
	}
}

// MARK: - Your Swift-based assembler/emulator hooks

func assembleSwiftASM(args: [String]) -> Int32 {
	// TODO: call your Swift 6502 assembler here
	print("Assembling \(args.joined(separator: " "))")
	return 0
}

func runSwiftBinary(args: [String]) -> Int32 {
	// TODO: call your Swift 6502 emulator here
	print("Running \(args.joined(separator: " "))")
	return 0
}

// MARK: - Main flow

do {
	print("Assembling \(sourceFile)...")
	let assembleStatus = try runProcess(assembleCommand)
	guard assembleStatus == 0 else {
		print("Assembly failed with status \(assembleStatus)")
		exit(assembleStatus)
	}

	print("Running output...")
	let runStatus = try runProcess(runCommand)
	guard runStatus == 0 else {
		print("Run failed with status \(runStatus)")
		exit(runStatus)
	}

	print("Done.")
} catch {
	fputs("Error: \(error)\n", stderr)
	exit(1)
}