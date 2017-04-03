//
//  FlicksViewController.swift
//  Flicks
//
//  Created by Doshi, Nehal on 4/1/17.
//  Copyright © 2017 Doshi, Nehal. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
class FlicksViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    var results: NSArray = []
    @IBOutlet weak var movieSearch: UISearchBar!
    var backgroundView: UIView?
    @IBOutlet weak var scrollView: UIScrollView!
    var basePath = "https://image.tmdb.org/t/p/w342"
    var searchActive : Bool = false
    var filtered = [NSDictionary()]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 140
        movieSearch.delegate = self
        
        
       
       
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)

        //let contentWidth = scrollView.bounds.width
        //let contentHeight = scrollView.bounds.height * 3
        //scrollView.contentSize = CGSize(contentWidth, contentHeight)
        
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        //  refreshControlAction(_refreshControl: refreshControl)
        
       // scrollView = UIScrollView(frame: view.bounds)
      //  scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = CGSize(width:tableView.bounds.width, height:tableView.bounds.height)
       // scrollView.autoresizingMask =  UIViewAutoresizing.flexibleHeight
       // scrollView.addSubview(tableView)
      //  view.addSubview(scrollView)
        
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Hide HUD once the network request comes back (must be done on main UI thread)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        //let responseFieldDictionary = responseDictionary["response"] as! NSDictionary?
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.results = responseDictionary["results"] as! NSArray
                        //print("results: \(self.results)")
                        self.tableView.reloadData()
                    }
                }
        });
       
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = UITableViewCell()
        // cell.textLabel?.text = "This is row \(indexPath.row)"
        
        //  return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        var movie = NSDictionary ();
        if(searchActive){
             movie = (filtered[indexPath.row] )
        } else {
             movie = (results[indexPath.row] as! NSDictionary)
        }
        //let movie = results[indexPath.row]
        
        
        if ((movie as? NSDictionary) != nil) {
            
            let imageUrlString = (movie as AnyObject).value(forKeyPath: "poster_path") as? String
            let imagePath = basePath + imageUrlString!
            print(imagePath)
            let imageUrl = URL(string: imagePath)!
            cell.photoImageView.setImageWith(imageUrl)
            
            let description = (movie as AnyObject).value(forKeyPath: "overview") as? String
            let title = (movie as AnyObject).value(forKeyPath: "original_title") as? String
            cell.movieDesc.text = description
            cell.movieTitle.text = title
            //cell.movieTitle.frame.height = 40
           // cell.movieDesc.frame.size=200
            
            cell.movieTitle.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
            cell.movieTitle.numberOfLines = 1
            cell.movieDesc.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
            cell.movieDesc.numberOfLines = 0

            cell.movieTitle.sizeToFit()
            cell.movieDesc.sizeToFit()
            
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
        
        return cell
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! MovieDetailsViewController
        
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let movie = results[indexPath.row]
        
        if ((movie as? NSDictionary) != nil)  {
            let imageUrlString = (movie as AnyObject).value(forKeyPath: "poster_path") as? String
            let imagePath = basePath + imageUrlString!
            
            let description = (movie as AnyObject).value(forKeyPath: "overview") as? String
            let title = (movie as AnyObject).value(forKeyPath: "original_title") as? String
            destinationViewController.movie_desc = description!
            destinationViewController.movie_title = title!
            destinationViewController.imageURL = imagePath
            
            
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
        
    }
    
    func refreshControlAction(_refreshControl: UIRefreshControl) {
        
       
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: {(dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    self.results = responseDictionary["results"] as! NSArray
                    self.tableView.reloadData()
                
                    _refreshControl.endRefreshing()
                    
                }
            }
        });
        task.resume()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if (self.results != nil)
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*
        filtered = (results.filter({ (text) -> Bool in
            let tmp: NSString = text as! NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        }) as! NSDictionary)
        */
        filtered = results.filter({
            let dict = $0 as? NSDictionary
            let temp:NSString = (dict!["original_title"] as? NSString)!
            print(temp)
            let range = temp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        
        }) as! [NSDictionary]
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}
