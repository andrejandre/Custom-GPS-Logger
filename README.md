# Custom-GPS-Logger
This app was made by myself, Andre Unsal, and is covered by the MIT License. Any questions or inquiries may be directed to andreunsal@gmail.com, and I am also available at https://www.linkedin.com/in/andreunsal/.

## Intro
The app was made for iOS 12.1 with XCode version 10.1. The purpose of the app is to log GPS at a custom frequency (800 Hz) for data analytics in a university research project. The data is exported as a CSV file which is then used for analysis using Python libraries. The GPS coordinates are converted to cartesian coordinates in real-time by taking into account earth's radius, and the polar coordinate system.

The repository for the research project is available at: https://github.com/andrejandre/MetaMotionR-Accelerometer-Research. It involves in-depth research with an accelerometer to improve on location tracking technology and algorithms. This GPS logger serves its purpose by providing valid GPS coordinates for comparison to accelerometer metrics.

## Demo

## Implementation
To get started, the view controller containing the functionality for this app will require the following libraries:
    
    import UIKit
    import CoreLocation
    import MapKit
   
Then, make sure you apply the follow inheritance to your class:

    CLLocationManagerDelegate
    
The following IBOutlet's need to be configured as well:

    // IBOutlet declarations
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startStop: UIButton!
    @IBOutlet weak var export: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var xCoordLabel: UILabel!
    @IBOutlet weak var yCoordLabel: UILabel!
    
For variables, the following declarations need to be made (these are necessary for time logging and CSV data):

    // Variable declarations:
    var locationManager: CLLocationManager!
    var i = 0.0 // global var for time logging
    var earthRadius = 6371000.00 // meters
    
    // Variables for CSV exports:
    var currentTime = [Double]()
    var userLatitude = [Double]()
    var userLongitude = [Double]()
    var userX = [Double]()
    var userY = [Double]()
    var newLine = [String]()
    
In the ```viewDidLoad``` function, the map must be initialized (this can be configured in XCode aswell, or done progammatically as shown):

    // View did load, handles basic map instantiation
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Instantiating the map
        mapView.delegate = self as? MKMapViewDelegate
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 1)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }
    
Then, an ```@IBAction func``` is created for the ```startStop``` UI button, it calls a function and begins the data logging process:

    // Start button pressed
    @IBAction func startPressed(_ sender: UIButton)
    {
        print("Start button was pressed.")
        determineMyCurrentLocation()
        startStop.isEnabled = false
        startStop.backgroundColor = UIColor.gray
        startStop.setTitle("logging...", for: UIControl.State.disabled)
    }
    
The function that triggers the GPS logging, ```determineMyCurrentLocation```, is shown below (it is the first step in the chain):

    // Instantiates and initializes CLLocationManager's location updates
    func determineMyCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        // Enables constant updates at a custom frequency using 'withTimeInterval'
        _ = Timer.scheduledTimer(withTimeInterval: 0.00125, repeats: true)
        {(timer) in
            self.i += timer.timeInterval
            self.timeLabel.text = ("\(self.i)")
            if CLLocationManager.locationServicesEnabled()
            {
                self.locationManager.startUpdatingLocation()
                self.locationManager.startUpdatingHeading()
            }
        }

    }
