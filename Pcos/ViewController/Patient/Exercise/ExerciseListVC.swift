//
//  ExerciseListVC.swift
//  Pcos
//
//  Created by Karthik Babu on 06/11/23.
//

import UIKit

class ExerciseListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var exerciseList: UITableView! {
        didSet {
                    exerciseList.delegate = self
                    exerciseList.dataSource = self
                }
    }
    var day : String = ""
        var currentDayExercises: [String] = []
    var imgName = ["yoga 1","yoga 2","yoga 3","yoga 4","yoga 1","yoga 3","yoga 2","yoga 4","yoga 3","yoga 4","yoga 1","yoga 3","yoga 2","yoga 4","yoga 1","yoga 2","yoga 1","yoga 3","yoga 2","yoga 4"]
    var Monday = ["Jumping Jacks","Assisted Lunges","Plie Squats","Walking Squats","Burpees","Mountain Climber","Pendulum Swings","Mountain Climber (again)","Flutter Kicks","Side Lunges","Backward Lunge","Crab Kicks","Deep Squat Hold","Shoulder Stretch (Left)","Shoulder Stretch (Right)","Straight Leg Fire Hydrant (Left)","Straight Leg Fire Hydrant (Right)","Glute Kick Back (Left)","Glute Kick Back (Right)"]
    var tuesday = ["Jumping Jacks","Assisted Lunges","Standing Bicycle Crunches","Russian Twist","Mountain Climber","Flutter Kicks","Leg Raises","Butt Bridge","Skipping without Rope","Standing Bicycle Crunches (again)","Plank","Reverse Crunches","Heel Touch","Reclined Oblique Twist","Heels to the Heavens", "Cross Knee Plank","Cross Arm Crunches","X-Man Crunch","Side Crunches (Left/Right)"]
    var wednesday = ["Dynamic Chest","Triceps Dips","Push-Ups","Diagonal Plank","Incline Push-Ups","star Crawl","Arm Scissors","Triceps Dips (again)","Push-Ups (again)","Diagonal Plank (again)","Incline Push-Ups (again)","Elbows Back","Leg Barbell Curl (Left)","Leg Barbell Curl (Right)","Jumping Jacks","Plank Taps","Elbows Back","Leg Barbell Curl (Left)", "Leg Barbell Curl (Right)","Jumping Jacks"]
    var thursday = ["Burpees", "Mountain Climber","Pendulum Swings","Mountain Climber (again)","Side Lunges","Quick Feet", "Butt Kicks","Skipping Without Rope", "Side Hop", "Squat Pulses","Straight Leg Fire Hydrant (Left)","Straight Leg Fire Hydrant (Right)","Glute Kick Back (Left)","Glute Kick Back (Right)", "Fast Spider Lunges","Side Leg Circuits (Left)", "Side Leg Circuits (Right)", "Deep Squat Hold","Diagonal Plank","Reclined Oblique Twist"]
    var friday = ["Plie Squats","Walking Squats","Burpees","Mountain Climber","Pendulum Swings","Mountain Climber (again)","Flutter Kicks","Side Lunges,Backward Lunge","Crab Kicks,Skipping without Rope,Side Hop,Quick Feet,Butt Kicks,Squat Pulses,Straight Leg Fire Hydrant (Left)","Straight Leg Fire Hydrant (Right)","Glute Kick Back (Left)","Glute Kick Back (Right)","Arm Scissors"]
    var saturday = ["Standing Bicycle Crunches","Russian Twist","Mountain Climber","Flutter Kicks","Leg Raises","Butt Bridge","Skipping without Rope","Standing Bicycle Crunches (again)","Plank,Reverse Crunches","Heel Touch","Reclined Oblique Twist","Heels to the Heavens","Cross Knee Plank","Cross Arm Crunches","X-Man Crunch","Side Crunches (Left)","Side Crunches (Right)","V-Hold","Cobra Stretch"]
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            customizeNavigationBar(title: "Exercise")
            updateExercisesForDay()
        }

        private func updateExercisesForDay() {
            switch day.lowercased() { 
            case "monday":
                currentDayExercises = Monday
            case "tuesday":
                currentDayExercises = tuesday
            case "wednesday":
                currentDayExercises = wednesday
            case "thursday":
                currentDayExercises = thursday
            case "friday":
                currentDayExercises = friday
            case "saturday":
                currentDayExercises = saturday
            default:
                currentDayExercises = []
            }
            exerciseList.reloadData()
        }

        
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return currentDayExercises.count
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exerciseList.deselectRow(at: indexPath, animated: true)
        
        let exerciseVideoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseVideoVC") as! ExerciseVideoVC
        let selectedExerciseName = currentDayExercises[indexPath.row]
        let imageName = imgName[indexPath.row % imgName.count]
        exerciseVideoVC.exerciseNameStr = selectedExerciseName.lowercased()
        exerciseVideoVC.exerciseImage = UIImage(named: imageName)
        
        self.navigationController?.pushViewController(exerciseVideoVC, animated: true)
    }

        
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = exerciseList.dequeueReusableCell(withIdentifier: "ExcerciseTabCell") as! ExcerciseTabCell
            let exerciseName = currentDayExercises[indexPath.row]
            cell.nameLbl.text = exerciseName
        cell.img.image = UIImage(named: imgName[indexPath.row])
            return cell
        }
        
    
}


class ExcerciseTabCell : UITableViewCell {
    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
}


