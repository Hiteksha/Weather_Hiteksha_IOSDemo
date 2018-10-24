//
//  WeatherViewController.swift
//  Weather_Hiteksha_IOSDemo
//
//  Created by Hiteksha G. Kathiriya on 21/10/18.
//  Copyright © 2018 Hiteksha G. Kathiriya. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    var Latitude : Float = 0.0
    var Longitude : Float = 0.0
    var JSON : NSDictionary = [:]
    var JSONForeCast : NSDictionary = [:]
    var arrForeCast :NSMutableArray = []
    @IBOutlet var lblVisibility: UILabel!
    @IBOutlet var lblFeelLike: UILabel!
    @IBOutlet var chanceOfrain: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblWeather: UILabel!
    @IBOutlet var lblTemprature: UILabel!
    @IBOutlet var lblMinTemp: UILabel!
    @IBOutlet var lblMaxTemp: UILabel!
    @IBOutlet var lblToday: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblWind: UILabel!
    @IBOutlet var todayDescription: UILabel!
    @IBOutlet var lblPressure: UILabel!
    
    @IBOutlet var lblSunRise: UILabel!
    @IBOutlet var lblSunSet: UILabel!
    
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var lblHumidity: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        self.getWeatherInfo()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    func getWeatherInfo(){
        let url : String = String(format: "http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=c6e381d8c7ff98f0fee43775817cf6ad&units=metric",Latitude, Longitude)
        
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if(statusCode == 200)
            {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    self.JSON = jsonResponse as! NSDictionary
                    
                    DispatchQueue.main.async {
                        
                        self.lblCity.text = self.JSON["name"]! as? String
                        
                        
                        let date = Date(timeIntervalSince1970: (self.JSON["dt"]! as? Double)!)
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
                        dateFormatter.locale = NSLocale.current
                        dateFormatter.dateFormat = "dd-MMM-yyyy" //Specify your format that you want
                        let strDate = dateFormatter.string(from: date)
                        
                        self.lblDate.text = strDate
                        let arrWeather = self.JSON["weather"]! as? NSArray
                        let dicWeather = arrWeather![0] as? NSDictionary
                        self.lblWeather.text = dicWeather!["description"] as? String
                        
                        
                        let dictSys = self.JSON["sys"] as? NSDictionary
                        let sunRise = dictSys?.value(forKey: "sunrise")
                        let date1 = Date(timeIntervalSince1970: (sunRise as? Double)!)
                        let dateFormatter1 = DateFormatter()
                        dateFormatter1.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
                        dateFormatter1.locale = NSLocale.current
                        dateFormatter1.dateFormat = "h:mm a" //Specify your format that you want
                        dateFormatter1.amSymbol = "AM"
                        dateFormatter1.pmSymbol = "PM"
                        let strDate1 = dateFormatter1.string(from: date1)
                        
                        let sunset = dictSys?.value(forKey: "sunset")
                        let date2 = Date(timeIntervalSince1970: (sunset as? Double)!)
                        
                        let strset = dateFormatter1.string(from: date2)
                        
                        self.lblSunRise.text = strDate1
                        self.lblSunSet.text = strset
                        
                        let dictPressure = self.JSON["main"] as? NSDictionary
                        let pressure:String = String(format: "%@", dictPressure?.value(forKey: "pressure") as! CVarArg)
                        
                        let temp:String = String(format: "%@", dictPressure?.value(forKey: "temp") as! CVarArg)
                        let minTemp:String = String(format: "%@", dictPressure?.value(forKey: "temp_min") as! CVarArg)
                        let maxTemp:String = String(format: "%@", dictPressure?.value(forKey: "temp_max") as! CVarArg)
                        
                        self.lblMinTemp.text = minTemp
                        self.lblMaxTemp.text = maxTemp
                        
                        let humidity:String = String(format: "%@", dictPressure?.value(forKey: "humidity") as! CVarArg)
                        
                        let dictWind = self.JSON["wind"] as? NSDictionary
                        let windSpeed:String = String(format: "%@", dictWind?.value(forKey: "speed") as! CVarArg)
                        
                        self.lblWind.text = NSString(format:"%@ km/hr", windSpeed) as String
                        
                        self.lblPressure.text =  NSString(format:"%@ hPa", pressure) as String
                        
                        self.lblHumidity.text = NSString(format:"%@ %", humidity) as String
                        
                        self.lblTemprature.text = NSString(format:"%@%@",temp, "\u{00B0}") as String
                        self.lblFeelLike.text = NSString(format:"%@%@",temp, "\u{00B0}") as String
                        
                        
                        let DictRainy = self.JSON["clouds"] as? NSDictionary
                        let lblRainy:String = String(format: "%@", DictRainy?.value(forKey: "all") as! CVarArg)
                        self.chanceOfrain.text = NSString(format:"%@ %", lblRainy) as String
                        self.lblVisibility.text = "0000"
                        
                        self.todayDescription.text = NSString(format:"Today: %@ Currently, It's a %@; the highest forecast for today is %@.",(dicWeather!["description"] as? String)!, NSString(format:"%@%@",temp, "\u{00B0}") as String, maxTemp) as String
                        
                    }
                }
                catch let error
                {
                    print(error)
                }
            }
            self.getForeCastDetail()
            }.resume()
    }
    // MARK: - UITableViewDataSource
    func getForeCastDetail(){
        let url : String = String(format: "http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&appid=c6e381d8c7ff98f0fee43775817cf6ad&units=metric",Latitude, Longitude)

        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if(statusCode == 200)
            {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    self.JSONForeCast = jsonResponse as! NSDictionary
                    
                    self.arrForeCast = self.JSONForeCast["list"]! as! NSMutableArray
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView.dataSource = self
                        self.collectionView.delegate = self
                        self.collectionView.register(UINib.init(nibName: "ForeCastCell", bundle: nil), forCellWithReuseIdentifier: "ForeCastCell")
                        
                    }
                }
                catch let error
                {
                    print(error)
                }
            }
            
            }.resume()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForeCast.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForeCastCell", for: indexPath as IndexPath) as! ForeCastCell
        
        var SelectedCell : NSDictionary = [:]
        SelectedCell = arrForeCast[indexPath.row] as! NSDictionary
        let date = Date(timeIntervalSince1970: SelectedCell.value(forKey: "dt") as! TimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"//Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        cell.lblDate.text = strDate
        
        
        let dictPressure = SelectedCell["main"] as? NSDictionary
        let temp:String = String(format: "%@", dictPressure?.value(forKey: "temp") as! CVarArg)
        let humidity:String = String(format: "%@", dictPressure?.value(forKey: "humidity") as! CVarArg)
        cell.lblTemprature.text = NSString(format:"%@%@",temp, "\u{00B0}") as String
        cell.lblHumidity.text = humidity
        let DictRainy = SelectedCell["clouds"] as? NSDictionary
        let lblRainy:String = String(format: "%@", DictRainy?.value(forKey: "all") as! CVarArg)
        cell.rainChances.text = NSString(format:"%@ %", lblRainy) as String
        let dictWind = SelectedCell["wind"] as? NSDictionary
        let windSpeed:String = String(format: "%@", dictWind?.value(forKey: "speed") as! CVarArg)
       cell.windInformation.text = NSString(format:"%@ km/hr", windSpeed) as String
        return cell
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
