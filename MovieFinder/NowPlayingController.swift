//
//  ViewController.swift
//  MovieFinder
//
//  Created by Vinay Desiraju on 3/24/23.
//

import UIKit

class NowPlayingController: UITableViewController {

    // create outlet for table view in movie controller.
    @IBOutlet var myTableView: UITableView!
    
    
    // variables for movie categories and details
   // var popularMovies : PopularMovie?
    var nowPlayingMovies : NowPlayingMovies?
   // var upcomingMovies : UpComingMovies?
 //   var topRatedMovies : TopRatedMovies?
    
    var moviePoster : [MoviePosters] = []
    var movieDetails : [MovieDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Image.png")!)
        // release the cached nib data of MovieCell to nib variable
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MovieCell") // register the nib object
        
        // call functions that fetch different categories of movies one after
        // the other and reload the table data.
        fetchNowPlayingMovies() {
            success in
            self.fetchImages()
            self.myTableView.reloadData()
        }
//               if success {
//                   self.fetchNowPlayingMovies(){ success in
//                       if success{
//                           self.fetchUpcomingMovies(){ success in
//                               if success {
//                                   self.fetchTopRatedMovies(){ success in
//                                       self.fetchImages()
//                                       self.myTableView.reloadData()
//                                   }
//                               }
//                           }
//                       }
//                   }
//               }
//           }
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }
    // The following 4 functions fetch movies from the categories - popular, playing now, upcoming and top rated.
    // These functions make calls to corresponding functions in the API_Request class and reloads the table view after each successfull call.
//    func fetchPopularMovies(completion: @escaping(Bool) -> Void) {
//        DispatchQueue.global(qos: .background).async{
//            API_Request.shared.getPopularMovies() { popularMovies in
//                DispatchQueue.main.async{
//                    if let popularMovies = popularMovies {
//                        self.popularMovies = popularMovies
//                        completion(true)
//                    }
//                    else
//                    {
//                        completion(false)
//                    }
//                    self.myTableView.reloadData()
//                }
//            }
//        }
//    }
    
    func fetchNowPlayingMovies(completion: @escaping(Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            API_Request.shared.getNowPlayingMovies(){ nowPlayingMovies in
                DispatchQueue.main.async {
                    if let nowPlayingMovies = nowPlayingMovies{
                        self.nowPlayingMovies = nowPlayingMovies
                        completion(true)
                    }
                    else
                    {
                        completion(false)
                    }
                   // debugPrint("NowPlayingMovies is retrieved")
                    self.myTableView.reloadData()
                }
                
            }
        }
    }
    
//    func fetchUpcomingMovies(completion: @escaping(Bool) -> Void){
//        DispatchQueue.global(qos: .background).async {
//            API_Request.shared.getUpcomingMovies(){ upComingMovies in
//                DispatchQueue.main.async {
//                    if let upComingMovies = upComingMovies{
//                        self.upcomingMovies = upComingMovies
//                        completion(true)
//                    }
//                    else
//                    {
//                        completion(false)
//                    }
//                    // UpComingMovies is retrieved
//                    self.myTableView.reloadData()
//                }
//
//            }
//        }
//    }
//
//    func fetchTopRatedMovies(completion: @escaping(Bool) -> Void)  {
//        DispatchQueue.global(qos: .background).async {
//            API_Request.shared.getTopRatedMovies(){ topRatedMovies in
//                DispatchQueue.main.async {
//                    if let topRatedMovies = topRatedMovies{
//                        self.topRatedMovies = topRatedMovies
//                        completion(true)
//                    }
//                    else
//                    {
//                        completion(false)
//                    }
//                   // topRatedMovies is retrieved
//                    self.myTableView.reloadData()
//                }
//
//            }
//        }
//    }
//
    // This function calls the downloadImgfromURL function in API_Request class for each movie category.
    // We do this to download the images for the related movie.
    func fetchImages() {
        let group = DispatchGroup()
        DispatchQueue.global(qos: .background).async {
            let nowplayingMovieResults = self.nowPlayingMovies?.results
//            let popularMovieResults = self.popularMovies?.results
//            let upcomingMoviesResults = self.upcomingMovies?.results
//            let topRatedMoviesResults = self.topRatedMovies?.results
//
//            if let results = popularMovieResults{
//                for results in results{
//                    group.enter()
//                    API_Request.shared.downloadImgfromURL(movieID: results.id, posterPath: results.posterPath){ moviePoster in
//                        DispatchQueue.main.async {
//                            if let moviePoster = moviePoster {
//                                self.moviePoster.append(moviePoster)
//                            }
//                            group.leave()
//                        }
//                    }
//                }
//            }
//            else
//            {
//                debugPrint("Result is nil")
//            }
            if let results = nowplayingMovieResults{
                for results in results{
                    group.enter()
                    API_Request.shared.downloadImgfromURL(movieID: results.id, posterPath: results.posterPath){ moviePoster in
                        DispatchQueue.main.async {
                            if let moviePoster = moviePoster {
                                self.moviePoster.append(moviePoster)
                            }
                            group.leave()
                        }
                    }
                }
            }
            else
            {
                debugPrint("Result is nil")
            }
//            if let results = topRatedMoviesResults{
//                for results in results{
//                    group.enter()
//                    API_Request.shared.downloadImgfromURL(movieID: results.id, posterPath: results.posterPath){ moviePoster in
//                        DispatchQueue.main.async {
//                            if let moviePoster = moviePoster {
//                                self.moviePoster.append(moviePoster)
//                            }
//                            group.leave()
//                        }
//                    }
//                }
//            }
//            else
//            {
//                debugPrint("Result is nil")
//            }
//            if let results = upcomingMoviesResults{
//                for results in results{
//                    group.enter()
//                    API_Request.shared.downloadImgfromURL(movieID: results.id, posterPath: results.posterPath){ moviePoster in
//                        DispatchQueue.main.async {
//                            if let moviePoster = moviePoster {
//                                self.moviePoster.append(moviePoster)
//                            }
//                            group.leave()
//                        }
//                    }
//                }
//            }
//            else
//            {
//                debugPrint("Result is nil")
//            }
            group.notify(queue: DispatchQueue.main) {
                debugPrint(self.movieDetails.count)
                self.myTableView.reloadData()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "DetailViewSegue", sender: indexPath)
    }
    
    // This function is configuring the back button title and functionality
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewSegue" {
            let dv = segue.destination as! MovieDetailView
            
            let indexPath = sender as! IndexPath
            let backButton = UIBarButtonItem(title: "Now Playing", style: .plain, target: nil, action: nil)
            navigationItem.backBarButtonItem = backButton
            dv.movieId = nowPlayingMovies?.results[indexPath.row].id ?? nil
//            switch indexPath.section{
//            case 0:
//                let backButton = UIBarButtonItem(title: "Popular Movies", style: .plain, target: nil, action: nil)
//                navigationItem.backBarButtonItem = backButton
//                dv.movieId = popularMovies?.results[indexPath.row].id ?? nil
//            case 1:
//                let backButton = UIBarButtonItem(title: "Now Playing", style: .plain, target: nil, action: nil)
//                navigationItem.backBarButtonItem = backButton
//                dv.movieId = nowPlayingMovies?.results[indexPath.row].id ?? nil
//            case 2:
//                let backButton = UIBarButtonItem(title: "Top Rated Movies", style: .plain, target: nil, action: nil)
//                navigationItem.backBarButtonItem = backButton
//                dv.movieId = topRatedMovies?.results[indexPath.row].id ?? nil
//            case 3:
//                let backButton = UIBarButtonItem(title: "Upcoming Movies", style: .plain, target: nil, action: nil)
//                navigationItem.backBarButtonItem = backButton
//                dv.movieId = upcomingMovies?.results[indexPath.row].id ?? nil
//            default:
//                let backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
//                navigationItem.backBarButtonItem = backButton
//                dv.movieId = nil
//            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This function is for the number of rows in each section for different movie categories.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        switch section{
//        case 0:
//            return popularMovies?.results.count ?? 0
//        case 1:
            return nowPlayingMovies?.results.count ?? 0
//        case 2:
//            return topRatedMovies?.results.count ?? 0
//        case 3:
//            return upcomingMovies?.results.count ?? 0
//        default:
//            return 0
//        }
    }
    
    // This function is for setting the title in the header section.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
//        switch section{
//        case 0:
//            return "Popular Movies"
//        case 1:
            return "Now Playing"
//        case 2:
//            return "Top Rated Movies"
//        case 3:
//            return "Upcoming Movies"
//        default:
//            return nil
//        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // this function is for the swipe action to remove a movie.
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delegteAction = UIContextualAction(style: .destructive, title: "Delete"){ (action, view, completion) in
//            switch indexPath.section{
//            case 0:
//                self.popularMovies?.results.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                completion(true)
//            case 1:
                self.nowPlayingMovies?.results.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
//            case 2:
//                self.topRatedMovies?.results.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                completion(true)
//            case 3:
//                self.upcomingMovies?.results.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                completion(true)
//            default:
//                completion(false)
//            }
        }
        let action = UISwipeActionsConfiguration(actions: [delegteAction])
        return action
    }
    
    // function to load the data in table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
//        switch indexPath.section{
//        case 0:
//            cell.movieTitle.text = popularMovies?.results[indexPath.row].title ?? "Unable to load Data"
//            if indexPath.row <= moviePoster.count {
//                var posterindex = -1
//                if let popularMovies = popularMovies{
//                    for index in 0..<moviePoster.count{
//                        if(moviePoster[index].movieId == popularMovies.results[indexPath.row].id)
//                        {
//                            posterindex = index
//                            break
//                        }
//                    }
//                }
//                if (posterindex >= 0)
//                {
//                    cell.movieImage.image = moviePoster[posterindex].moviewpos
//                }
//                else
//                {
//                    cell.movieImage.image = nil
//                }
//            }
//            else
//            {
//                cell.movieImage.image = nil
//            }
//        case 1:
      //  if cell.fav.isOff{
//            let userDefaults = UserDefaults.standard
//
//            // Write/Set Value
//            userDefaults.set(true, forKey: "myKey")
          //  cell.votecount.text = "hey"
     //   }
     //   else{
        let vote = nowPlayingMovies?.results[indexPath.row].voteCount ?? 0
            cell.votecount.text = "Votes:\(String(vote))"
            cell.movieTitle.text = nowPlayingMovies?.results[indexPath.row].title ?? "Unable to load data"
      //  }
        
        if indexPath.row <= moviePoster.count {
                var posterindex = -1
                if let nowPlayingMovies = nowPlayingMovies{
                    for index in 0..<moviePoster.count{
                        if(moviePoster[index].movieId == nowPlayingMovies.results[indexPath.row].id)
                        {
                            posterindex = index
                            break
                        }
                    }
                }
                if (posterindex >= 0)
                {
                    cell.movieImage.image = moviePoster[posterindex].moviewpos
                }
                else
                {
                    cell.movieImage.image = nil
                }
            }
            else
            {
                cell.movieImage.image = nil
            }
        
        cell.fav.isOn = false
        API_Request.shared.checkIfMovieIsFavorited(movieId: self.nowPlayingMovies?.results[indexPath.row].id ?? 0) { isFavorited in
            if let isFavorited = isFavorited {
                DispatchQueue.main.async {
                    if isFavorited {
                        cell.fav.isOn = true
                       // cell.votecount.text = "hey"
                    }
                    
                }
            } else {
                print("error in checkiffavorite nowplaying")
            }
        }
        
        cell.switchValueChanged = { isOn in
                if isOn {
                    print("Switch for cell \(indexPath.row) turned on")
                    let movieid = self.nowPlayingMovies?.results[indexPath.row].id ?? 0
                    API_Request.shared.addToFavorites(movieId: movieid, sessionId: "a61697cabf65b0d199b64d9d08026bb10f6f6a87", apiKey: "41f36ebf35f37b9fa80bd760c722709f"){ error in
                        if let error = error {
                            print("Error adding movie to favorites: \(error.localizedDescription)")
                        } else {
                            print("Movie added to favorites successfully!")
                        }
                    }
                    
                } else {
                    print("Switch for cell \(indexPath.row) turned off")
                    let movieid = self.nowPlayingMovies?.results[indexPath.row].id ?? 0
                    API_Request.shared.removeFromFavorites(movieId: movieid, sessionId: "a61697cabf65b0d199b64d9d08026bb10f6f6a87", apiKey: "41f36ebf35f37b9fa80bd760c722709f"){ error in
                        if let error = error {
                            print("Error removing movie from favorites: \(error.localizedDescription)")
                        } else {
                            print("Movie removed from favorites successfully!")
                        }
                    }
                }
            }
        
        
//        case 2:
//            cell.movieTitle.text = topRatedMovies?.results[indexPath.row].title ?? "Unable to load data"
//            if indexPath.row <= moviePoster.count {
//                var posterindex = -1
//                if let topRatedMovies = topRatedMovies{
//                    for index in 0..<moviePoster.count{
//                        if(moviePoster[index].movieId == topRatedMovies.results[indexPath.row].id)
//                        {
//                            posterindex = index
//                            break
//                        }
//                    }
//                }
//                if (posterindex >= 0)
//                {
//                    cell.movieImage.image = moviePoster[posterindex].moviewpos
//                }
//                else
//                {
//                    cell.movieImage.image = nil
//                }
//            }
//            else
//            {
//                cell.movieImage.image = nil
//            }
//        case 3:
//            cell.movieTitle.text = upcomingMovies?.results[indexPath.row].title ?? "Unable to load data"
//            if indexPath.row <= moviePoster.count {
//                var posterindex = -1
//                if let upComingMovies = upcomingMovies{
//                    for index in 0..<moviePoster.count{
//                        if(moviePoster[index].movieId == upComingMovies.results[indexPath.row].id)
//                        {
//                            posterindex = index
//                            break
//                        }
//                    }
//                }
//                if (posterindex >= 0)
//                {
//                    cell.movieImage.image = moviePoster[posterindex].moviewpos
//                }
//                else
//                {
//                    cell.movieImage.image = nil
//                }
//            }
//            else
//            {
//                cell.movieImage.image = nil
//            }
//        default:
//            cell.movieTitle.text = "Unable to load Data"
//            cell.movieImage.backgroundColor = .green
//        }
        return cell
    }

}

