//
//  main.swift
//  mp4SearchAndWrite
//
//  Created by Kyle Grieder on 9/4/18.
//  Copyright © 2018 Kyle Grieder. All rights reserved.
//

import Foundation

let mp4SearchAndWrite = Mp4SearchAndWrite()
let helpers = Helpers()

func main() {
    
    if (CommandLine.argc < 2) {
        mp4SearchAndWrite.staticMode()
    } else {
        let terms = mp4SearchAndWrite.getTerms()
        let type = terms["type"] as? String
        
        // logic paths for terms: movie, tv show, help, staic mode
        if (terms["help"] != nil) {
            mp4SearchAndWrite.helpMode()
        } else if (type == "movie") {
        
            if let filePath = terms["path"] as? String {
                
                var titleString: String?
                var yearString: String?
                
                if let titleTerm = terms["title"] as? String {
                    titleString = titleTerm
                } else {
                    if let titleLast = filePath.split(separator: "/").last,
                        let titleFirst = String(titleLast).split(separator: "(").first {
                        titleString = String(titleFirst)
                    } else {
                        consoleIO.writeMessage("Couldn't parse title...")
                    }
                }
                
                if let yearTerm = terms["year"] as? String {
                    yearString = yearTerm
                } else {
                    if let yearLast = filePath.split(separator: "/").last,
                        let yearLastAgain = String(yearLast).split(separator: "(").last,
                        let yearFirst = String(yearLastAgain).split(separator: ")").first {
                         yearString = String(yearFirst)
                    } else {
                        consoleIO.writeMessage("Couldn't parse year...")
                    }
                }
                
                if let title = titleString, let year = yearString {
                    let movie = Movie(withTitle: title, andYear: year)
                    
                    let artworkPath = "/" + filePath.split(separator: "/").dropLast().joined(separator: "/") + "/poster-" + title + ".jpg"
                    helpers.savePosterImage(fromData: movie.artworkData, toPath: artworkPath)
                    
                    if let title = movie.title,
                        let genre = movie.genre,
                        let releaseDate = movie.releaseDate,
                        let longDesc = movie.longDesc,
                        let storeDesc = movie.storeDesc,
                        let mpaaCert = movie.mpaaCertification {
                        
                        let arguments = [filePath, artworkPath, title, genre, releaseDate, longDesc, storeDesc, mpaaCert, movie.stik]
                        helpers.mp4WriteScript(withArguments: arguments)
                    } else {
                        consoleIO.writeMessage("You're missing something...")
                    }
                }
            }
        } else if (type == "tv") {
            
        }
    }
}
main()
