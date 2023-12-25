//
//  MovieDetails.swift
//  MovieFinder
//
//  Created by Vinay Desiraju on 3/24/23.
//

import UIKit

class MovieDetailView: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
        
    // creating outlets for Movie Detail View
    @IBOutlet weak var starView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    var movieId: Int?
    var movieDetails : MovieDetails?
    var imagePaths : ImagePaths?
    var movieImages : MovieImages?
    
    // viewDidLoad function to release the cached nib data of ImageCollectionView to nib variable.
    // Then obtaining all movie image related data.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ImageCollectionView" , bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageCollectionView")
        
        MovieDetails(){ success in
            if success{
                self.getImagePaths(){ success in
                    if success{
                        self.getImages()
                        self.assignlabels()
                    }
                }
            }
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // Function to get images. (Calls downloadMovieImage from API_Request class)
    func getImages() {
        DispatchQueue.global(qos: .background).async {
            API_Request.shared.downloadMovieImage(imgPaths: self.imagePaths!){ movieImages in
                DispatchQueue.main.async {
                    if let movieImages = movieImages{
                        self.movieImages = movieImages
                        debugPrint("Retrieval in Detail View")
                    }
                    self.collectionView.reloadData()
                }
                
            }
        }
    }
    
    // Function to get Image Paths. (Calls getMovieImageBackPaths from API_Request class)
    func getImagePaths(completion: @escaping(Bool) -> Void){
        DispatchQueue.global(qos: .background).async {
            API_Request.shared.getMovieImageBackPaths(movieID: self.movieId!){ imagePaths in
                DispatchQueue.main.async {
                    if let imagePaths = imagePaths{
                        self.imagePaths = imagePaths
                        completion(true)
                    }
                }
            }
        }
    }
    
    // Function to fetch MovieDetails. (Calls getMovieDetails from API_Request class)
    func MovieDetails(completion: @escaping(Bool) -> Void){
        DispatchQueue.global(qos: .background).async {
            API_Request.shared.getMovieDetails(movieID: self.movieId!){ movieDetails in
                DispatchQueue.main.async {
                    if let movieDetails = movieDetails{
                        self.movieDetails = movieDetails
                        completion(true)
                        //debugPrint(self.movieDetails!.overview)
                    }
                }
            }
        }
    }
    
    // Function to assign labels to all fields of a specific movie.
    func assignlabels()
    {
        movieTitle.text = movieDetails?.title ?? "No Title"
        releaseDate.text = movieDetails?.releaseDate ?? "Not Available"
        var movieGenres = ""
        if let movieDetails = movieDetails{
            for genre in movieDetails.genres{
                if movieGenres == "" {
                    movieGenres = genre.name
                }
                else{
                    movieGenres = movieGenres + ", " + genre.name
                }
            }
        }
        genre.text = movieGenres
        movieDesc.text = "Description:\n" + (movieDetails?.overview ?? "Description Unavailable")
        
        let rating = (movieDetails?.voteAverage ?? 0.0) / 2.0
        var roundedRating = round(Double(rating * 2.0)) / 2.0
        
        for case let imageView as UIImageView in starView.arrangedSubviews {
            if roundedRating > 1.0 {
                imageView.image = UIImage(systemName: "star.fill")
                roundedRating = roundedRating - 1.0
            }
            else if roundedRating == 0.5 {
                imageView.image = UIImage(systemName: "star.leadinghalf.fill")
                roundedRating = 0.0
            } else{
                imageView.image  = UIImage(systemName: "star")
            }
                                    
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePaths?.backdrops.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionView", for: indexPath) as! ImageCollector
        
        if let movieImages = movieImages {
            cell.movieImages.image = movieImages.movieImages[indexPath.row]
        }
        else{
            cell.movieImages.backgroundColor = .red
        }
        cell.layoutIfNeeded()
        
        return cell
    }

}

