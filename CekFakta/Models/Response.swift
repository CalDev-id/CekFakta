//
//  Response.swift
//  CekFakta
//
//  Created by Heical Chandra on 24/11/25.
//
import Foundation

struct PredictionResponse: Codable {
    let url: String
    let title: String
    let content: String
    let classification: Classification?
    let evidence_links: [String]?
    let evidence_scraped: [EvidenceScraped]?
    let explanation: String?
    let error: String?
}

struct EvidenceScraped: Codable {
    let judul: String?
    let tanggal: String?
    let sumber: String?
    let link: String?
    let content: String?
    let featured_image: String?
}

struct Classification: Codable {
    let final_label: String
    let final_confidence: Double
}
