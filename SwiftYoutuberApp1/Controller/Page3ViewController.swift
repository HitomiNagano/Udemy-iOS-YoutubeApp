//
//  Page1ViewController.swift
//  SwiftYoutuberApp1
//
//  Created by Hitomi Nagano on 2021/04/14.
//

import UIKit
import SegementSlide
import Alamofire
import SwiftyJSON
import SDWebImage
import Keys

class Page3ViewController: UITableViewController, SegementSlideContentScrollViewDelegate {
    var youtubeData = YoutubeData()
    
    var videoIDArray = [String]()
    var publishedAtArray = [String]()
    var titleArray = [String]()
    var imageURLStringArray = [String]()
    var youtubeURLArray = [String]()
    var channelTitleArray = [String]()
    
    let refresh = UIRefreshControl()
    let keys = SwiftYoutuberApp1Keys()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(updateData), for: .valueChanged)
        getYoutubeData()
        tableView.reloadData()
    }
    
    @objc func updateData() {
        getYoutubeData()
        tableView.reloadData()
        refresh.endRefreshing()
    }

    // Quick Start https://github.com/Jiar/SegementSlide#quick-start
    @objc var scrollView: UIScrollView {
        return tableView
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videoIDArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/5
    }
    
    func getYoutubeData() {
        // Get Request
        let requestUrl = "https://www.googleapis.com/youtube/v3/search?key=\(keys.youtubeAPIKey)&q=Front-End&part=snippet&maxResults=40&order=date"
        
        let encodedUrl = requestUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        // 参考：https://qiita.com/k_moto/items/964b2e581e9eca312425
        AF.request(encodedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {(response) in
            switch response.result {
                case .success:
                    for i in 0...19 {
                        let json: JSON = JSON(response.data as Any)
                        let videoID = json["items"][i]["id"]["videoId"].string
                        // let publishedAt = json["items"][i]["snippet"]["publishedAt"].string
                        let title = json["items"][i]["snippet"]["title"].string
                        let imageURLString = json["items"][i]["snippet"]["thumbnails"]["default"]["url"].string
                        let youtubeURL = "https://www.youtube.com/watch?v=\(videoID!)"
                        let channelTitle = json["items"][i]["snippet"]["channelTitle"].string

                        self.videoIDArray.append(videoID!)
                        // publishedAtArray.append(publishedAt!)
                        self.titleArray.append(title!)
                        self.imageURLStringArray.append(imageURLString!)
                        self.youtubeURLArray.append(youtubeURL)
                        self.channelTitleArray.append(channelTitle!)
                    }
                    break
                case .failure(let Error):
                    print(Error)
                    break
            }
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let profileImegeURL = URL(string: imageURLStringArray[indexPath.row] as String)!
        // cell.imageView?.sd_setImage(with: profileImegeURL, completed: nil)
        cell.imageView?.sd_setImage(with: profileImegeURL, completed: { (image, error, _, _) in
            if error == nil {
                // 画面更新の必要があった場合 にすべて 即座に 配置
                // 参考：https://qiita.com/h1d3mun3/items/467c9a16d30b5de73969#setneedslayout
                cell.setNeedsLayout()
            }
        })
        cell.textLabel?.text = titleArray[indexPath.row]
        // publishedAt を公開していない場合があるため、コメントアウト
        // cell.detailTextLabel?.text = publishedAtArray[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 5
        cell.detailTextLabel?.numberOfLines = 5

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewController = WebViewController()
        let url = youtubeURLArray[indexPath.row]
        UserDefaults.standard.set(url, forKey: "url")
        present(webViewController, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
