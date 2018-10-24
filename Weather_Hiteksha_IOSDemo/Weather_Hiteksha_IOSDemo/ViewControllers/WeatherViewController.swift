//
//  WeatherViewController.swift
//  Weather_Hiteksha_IOSDemo
//
//  Created by Hiteksha G. Kathiriya on 22/10/18.
//  Copyright © 2018 Hiteksha G. Kathiriya. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    // Alloc Latitude with Float
    var Latitude : Float = 0.0
    
    // Alloc Longitude with Float
    var Longitude : Float = 0.0
    
    // Alloc JSON with NSDictionary
    var JSON : NSDictionary = [:]
    
    // Alloc JSONForeCast with NSDictionary
    var JSONForeCast : NSDictionary = [:]
    
    // Alloc arrForeCast with NSMutableArray
    var arrForeCast :NSMutableArray = []
    
    //UILable declaration with lblVisibility
    @IBOutlet var lblVisibility: UILabel!
    
    //UILable declaration with lblFeelLike
    @IBOutlet var lblFeelLike: UILabel!
    
    //UILable declaration with chanceOfrain
    @IBOutlet var chanceOfrain: UILabel!
    
    //UILable declaration with lblCity
    @IBOutlet var lblCity: UILabel!
    
    //UILable declaration with lblWeather
    @IBOutlet var lblWeather: UILabel!
    
    //UILable declaration with lblTemprature
    @IBOutlet var lblTemprature: UILabel!
    
    //UILable declaration with lblMinTemp
    @IBOutlet var lblMinTemp: UILabel!
    
    //UILable declaration with lblMaxTemp
    @IBOutlet var lblMaxTemp: UILabel!
    
    //UILable declaration with lblToday
    @IBOutlet var lblToday: UILabel!
    
    //UILable declaration with lblDate
    @IBOutlet var lblDate: UILabel!
    
    //UILable declaration with lblWind
    @IBOutlet var lblWind: UILabel!
    
    //UILable declaration with todayDescription
    @IBOutlet var todayDescription: UILabel!
    
    //UILable declaration with lblPressure
    @IBOutlet var lblPressure: UILabel!
    
    //UILable declaration with lblSunRise
    @IBOutlet var lblSunRise: UILabel!
    
    //UILable declaration with lblSunSet
    @IBOutlet var lblSunSet: UILabel!
    
    //UILable declaration with lblHumidity
    @IBOutlet var lblHumidity: UILabel!
    
    //UIScrollView declaration with scrollview
    @IBOutlet var scrollview: UIScrollView!
    
    //UICollectionView declaration with collectionView
    @IBOutlet var collectionView: UICollectionView!
    
    //View Controller LifeCycle methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Set Scrollview ContentSizr
        scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        
        //API Calling for Get Today's Weather details
        self.getWeatherInfo()
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    //API Calling for Get Today's Weather details
    func getWeatherInfo()
    {
        let url : String = String(format: "http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=c6e381d8c7ff98f0fee43775817cf6ad&units=metric",Latitude, Longitude)
        
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if(statusCode == 200)
            {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    self.JSON = jsonResponse as! NSDictionary
                
                    DispatchQueue.main.async
                        {
                        //Set lblCity value
                        self.lblCity.text = self.JSON["name"]! as? String
                        
                        let date = Date(timeIntervalSince1970: (self.JSON["dt"]! as? Double)!)
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "IST") //Set timezone that you want
                        dateFormatter.locale = NSLocale.current
                        dateFormatter.dateFormat = "dd-MMM-yyyy" //Specify your format that you want
                        let strDate = dateFormatter.string(from: date)
                        
                        //Set lblDate value
                        self.lblDate.text = strDate
                        let arrWeather = self.JSON["weather"]! as? NSArray
                        let dicWeather = arrWeather![0] as? NSDictionary
                        
                        //Set lblDate value
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
                        
                        //Set lblSunRise value
                        self.lblSunRise.text = strDate1
                            
                        //Set lblSunSet value
                        self.lblSunSet.text = strset
                        
                        let dictPressure = self.JSON["main"] as? NSDictionary
                        let pressure:String = String(format: "%@", dictPressure?.value(forKey: "pressure") as! CVarArg)
                        
                        let temp:String = String(format: "%@", dictPressure?.value(forKey: "temp") as! CVarArg)
                        let minTemp:String = String(format: "%@", dictPressure?.value(forKey: "temp_min") as! CVarArg)
                        let maxTemp:String = String(format: "%@", dictPressure?.value(forKey: "temp_max") as! CVarArg)
                        
                        //Set lblMinTemp value
                        self.lblMinTemp.text = minTemp
                            
                        //Set lblMaxTemp value
                        self.lblMaxTemp.text = maxTemp
                        
                        let humidity:String = String(format: "%@", dictPressure?.value(forKey: "humidity") as! CVarArg)
                        
                        let dictWind = self.JSON["wind"] as? NSDictionary
                        let windSpeed:String = String(format: "%@", dictWind?.value(forKey: "speed") as! CVarArg)
                        
                        //Set lblWind value
                        self.lblWind.text = NSString(format:"%@ km/hr", windSpeed) as String
                        
                        //Set lblPressure value
                        self.lblPressure.text =  NSString(format:"%@ hPa", pressure) as String
                        
                        //Set lblHumidity value
                        self.lblHumidity.text = NSString(format:"%@ %", humidity) as String
                        
                        //Set lblTemprature value
                        self.lblTemprature.text = NSString(format:"%@%@",temp, "\u{00B0}") as String
                            
                        //Set lblFeelLike value
                        self.lblFeelLike.text = NSString(format:"%@%@",temp, "\u{00B0}") as String
                        
                        
                        let DictRainy = self.JSON["clouds"] as? NSDictionary
                        let lblRainy:String = String(format: "%@", DictRainy?.value(forKey: "all") as! CVarArg)
                        self.chanceOfrain.text = NSString(format:"%@ %", lblRainy) as String
                            
                        //Set lblVisibility value
                        self.lblVisibility.text = "0000"
                        
                        //Set todayDescription value
                        self.todayDescription.text = NSString(format:"Today: %@ Currently, It's a %@; the highest forecast for today is %@.",(dicWeather!["description"] as? String)!, NSString(format:"%@%@",temp, "\u{00B0}") as String, maxTemp) as String
                    }
                }
                catch let error
                {
                    print(error)
                }
            }
             //API Calling for Get 5 days forecast details
            self.getForeCastDetail()
            }.resume()
    }
    
    //API Calling for Get 5 days forecast details
    func getForeCastDetail()
    {
        let url : String = String(format: "http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&appid=c6e381d8c7ff98f0fee43775817cf6ad&units=metric",Latitude, Longitude)

        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if(statusCode == 200)
            {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    self.JSONForeCast = jsonResponse as! NSDictionary
                    
                    //Add 5 day forecast in arrForeCast
                    self.arrForeCast = self.JSONForeCast["list"]! as! NSMutableArray
                    DispatchQueue.main.async
                        {
                         //Reload CollectionView
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
    
    //CollectionView Delegate & DataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrForeCast.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
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
        
        //Set lblDate value
        cell.lblDate.text = strDate
        let dictPressure = SelectedCell["main"] as? NSDictionary
        let temp:String = String(format: "%@", dictPressure?.value(forKey: "temp") as! CVarArg)
        let humidity:String = String(format: "%@", dictPressure?.value(forKey: "humidity") as! CVarArg)
        
        //Set lblTemprature value
        cell.lblTemprature.text = NSString(format:"%@%@",temp, "\u{00B0}") as String
        
        //Set lblHumidity value
        cell.lblHumidity.text = humidity
        let DictRainy = SelectedCell["clouds"] as? NSDictionary
        let lblRainy:String = String(format: "%@", DictRainy?.value(forKey: "all") as! CVarArg)
        
        //Set rainChances value
        cell.rainChances.text = NSString(format:"%@ %", lblRainy) as String
        let dictWind = SelectedCell["wind"] as? NSDictionary
        let windSpeed:String = String(format: "%@", dictWind?.value(forKey: "speed") as! CVarArg)
        
        //Set windInformation value
       cell.windInformation.text = NSString(format:"%@ km/hr", windSpeed) as String
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    
    }
}
