//
//  NewsModel.swift
//  CekFakta
//
//  Created by Heical Chandra on 09/12/25.
//

import Foundation

struct News: Identifiable, Codable {
    let id: String
    let url: String?
    let title: String?
    let content: String?
    let classification: String?
    let evidence_link: [String]?
    let evidence_scraped: [EvidenceScraped2]?
    let explanation: String?
    let inserted_at: String? 
    let updated_at: String?
}

struct EvidenceScraped2: Codable {
    let url: String?
    let content: EvidenceContent2?
}

struct EvidenceContent2: Codable {
    let judul: String?
    let tanggal: String?
    let sumber: String?
    let link: String?
    let content: String?
    let featured_image: String?
}
