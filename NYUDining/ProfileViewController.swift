//
//  ProfileViewController.swift
//  NYUDining
//
//  Created by Jesus Leal on 6/20/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import Foundation

import UIKit
import Alamofire


class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var school: UILabel!
    
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var major: UILabel!
    
    @IBOutlet weak var likes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = "Name Filler"
        
        school.text = "School Filler"
        
        year.text = "Sophomore"
        
        major.text = "Major Filler"
        
        likes.text = "This might take up more space than one line, what happens if it does?"
        
        
    }
}
