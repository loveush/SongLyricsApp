//
//  StorageManager.swift
//  SomeApp
//
//  Created by Любовь Ушакова on 07.02.2025.
//

import UIKit
import CoreData

//MARK: - CRUD
final class StorageManager: NSObject {
    public static let shared = StorageManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func addSong(id: Int64, title: String, artist: String, lyrics: String) {
        guard let songEntityDescription = NSEntityDescription.entity(forEntityName: "Song", in: context) else {
            print("Unable to create description")
            return
        }
        let song = Song(entity: songEntityDescription, insertInto: context)
        song.id = id
        song.title = title
        song.artist = artist
        song.lyrics = lyrics
        
        appDelegate.saveContext()
    }
    
    func fetchSongs() -> [Song] {
        let fetchRequest = (NSFetchRequest<NSFetchRequestResult>(entityName: "Song"))
        do {
            return (try? context.fetch(fetchRequest) as? [Song]) ?? []
        }
    }
    
    func fetchSong(with id: Int64) -> Song? {
        let fetchRequest = (NSFetchRequest<NSFetchRequestResult>(entityName: "Song"))
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let songs =  try? context.fetch(fetchRequest) as? [Song]
            return songs?.first
        }
    }
    
    func deleteSong(with id: Int64) {
        let fetchRequest = (NSFetchRequest<NSFetchRequestResult>(entityName: "Song"))
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let songs = try? context.fetch(fetchRequest) as? [Song],
                  let song = songs.first else { return }
            context.delete(song)
        }
        
        appDelegate.saveContext()
    }
}
