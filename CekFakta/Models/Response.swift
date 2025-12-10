//
//  Response.swift
//  CekFakta
//
//  Created by Heical Chandra on 24/11/25.
//
import Foundation

struct PredictionResponse: Codable {
    let input_user: InputUser?
    let classification: Classification?
    let evidence_links: [String]?
    let evidence_scraped: [EvidenceScraped]?
    let explanation: String?
    let error: String?
}

struct InputUser: Codable {
    let url: String
    let title: String
    let content: String
}

struct EvidenceScraped: Codable {
    let url: String
    let content: EvidenceContent
}

struct EvidenceContent: Codable {
    let judul: String?
    let tanggal: String?
    let sumber: String?
    let link: String?
    let content: String?
    let featured_image: String?
}


struct Classification: Codable {
    let label: String
    let confidence: Double
    let probs: [[Double]]
}
