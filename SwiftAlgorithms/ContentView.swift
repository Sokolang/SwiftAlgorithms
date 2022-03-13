//
//  ContentView.swift
//  SwiftAlgorithms
//
//  Created by Anzhelika Sokolova on 13.03.2022.
//
import Algorithms
import SwiftUI


struct Student {
    let name: String
    let grade: String
}

struct City {
    let name: String
    let country: String
}

struct ContentView: View {
    
    var body: some View {
        Form {
            Section ("Chain") {
                Button("Chain names1 + names2") {
                    /* for name in names1 + names2 {
                     print(name)
                     }
                     chain() creates a new sequence by concatenating two others, without performing any additional allocations.*/
                    let names1 = ["Jane", "Elizabeth", "Mary", "Kitty"]
                    let names2 = ["Daphne", "Eloise", "Francesca", "Hyacinth"]
                    for name in chain(names1, names2) {
                        print(name)
                    }
                }
                /*
                 Behind the scenes chain() stores references to your existing two sequences, and effectively just ties their iterators together so that as one ends another one begins.
                 
                 This works with other sequence types too, so we can efficiently check whether a value lies within two different ranges:
                 */
                Button("Chain check ranges") {
                    let tooLow = 0...20
                    let tooHigh = 80...100
                    let outOfBounds = chain(tooLow, tooHigh)
                    let value = 35
                    print(outOfBounds.contains(value))
                }
                /*
                 Even better, this works across any kinds of sequence, so we could chain a range and an array:
                 */
                Button("Chain different sequence") {
                    let reservedSeats = 0...50
                    let unavailableSeats = [61, 68, 75, 76, 77, 92]
                    let disallowed = chain(reservedSeats, unavailableSeats)
                    
                    let requestedSeat = 39
                    print(disallowed.contains(requestedSeat))
                }
            }
            Section ("Chunked") {
                Button("Chunked") {
                    let results = [
                        Student(name: "Taylor", grade: "A"),
                        Student(name: "Sophie", grade: "A"),
                        Student(name: "Bella", grade: "B"),
                        Student(name: "Rajesh", grade: "C"),
                        Student(name: "Tony", grade: "C"),
                        Student(name: "Theresa", grade: "D"),
                        Student(name: "Boris", grade: "F")
                    ]
                    let studentsByGrade = results.chunked(on: \.grade)
                    
                    for (grade, students) in studentsByGrade {
                        print("Grade \(grade)")
                        
                        for student in students {
                            print("\t\(student.name)")
                        }
                        
                        print()
                    }
                }
                /*
                 This will automatically create a new chunk whenever the value being checked changes, so you need to be careful if your value jumps around. In our code above the student grades all appear in order – the two As are together, as are the two Cs – so this isn’t a problem, but if we wanted to chunk by student name we should sort them first to make sure the starting letters are grouped together:
                 */
                Button("Chunked sorted") {
                    let results = [
                        Student(name: "Taylor", grade: "A"),
                        Student(name: "Sophie", grade: "A"),
                        Student(name: "Bella", grade: "B"),
                        Student(name: "Rajesh", grade: "C"),
                        Student(name: "Tony", grade: "C"),
                        Student(name: "Theresa", grade: "D"),
                        Student(name: "Boris", grade: "F")
                    ]
                    let studentsByName = results.sorted { $0.name < $1.name }.chunked(on: \.name.first!)
                    
                    for (firstLetter, students) in studentsByName {
                        print(firstLetter)
                        
                        for student in students {
                            print("\t\(student.name)")
                        }
                        
                        print()
                    }
                }
                /*
                 There’s an alternative chunking method that lets us split up a sequence by number of items in each chunk. For example we could split our students up into pairs like this:
                 */
                Button("Chunked split") {
                    let results = [
                        Student(name: "Taylor", grade: "A"),
                        Student(name: "Sophie", grade: "A"),
                        Student(name: "Bella", grade: "B"),
                        Student(name: "Rajesh", grade: "C"),
                        Student(name: "Tony", grade: "C"),
                        Student(name: "Theresa", grade: "D"),
                        Student(name: "Boris", grade: "F")
                    ]
                    let pairs = results.chunks(ofCount: 2)
                    
                    for pair in pairs {
                        let names = ListFormatter.localizedString(byJoining: pair.map(\.name))
                        print(names)
                    }
                    /*
                     Be careful: chunking data will return an array slice rather than an array, because it’s more efficient. This means if you try and read indices like 0 and 1 for our pair you’ll hit a problem.
                     */
                }
            }
            Section ("RandomSample") {
                /*
                 randomSample(count:) is the fastest, and it works on all sequences. However, it doesn’t retain the order of your elements, so you’ll get back N random, non-duplicate elements in any order.
                 */
                Button("RandomSample") {
                    let lotteryBalls = 1...50
                    let winningNumbers = lotteryBalls.randomSample(count: 7)
                    print(winningNumbers)
                }
                /*
                 If you specify a count equal to or greater than the number of items in your sequence, the entire sequence will be returned – still in a random order.
                 
                 An alternative is randomStableSample(count:), which works a little differently. First, it works only on collections, because it needs to know how many items it’s choosing from, and it also runs a little slower than randomSample(count:). However, it does retain the order of your items, which can be helpful:
                 */
                Button("randomStableSample") {
                    let people = ["Chidi", "Eleanor", "Jason", "Tahani"]
                    let selected = people.randomStableSample(count: 2)
                    print(selected)
                }
            }
            Section ("Stride") {
                Button("Stride") {
                    let numbers = 1...1000
                    let oddNumbers = numbers.striding(by: 2)
                    
                    for oddNumber in oddNumbers {
                        print(oddNumber)
                    }
                }
                Button("Stride String") {
                    let inputString = "a1b2c3d4e5"
                    let letters = inputString.striding(by: 2)
                    
                    for letter in letters {
                        print(letter)
                    }
                }
                /*
                 I use this recently to handle decrypting columnar transposition ciphers, where plaintext letters are spaced out at fixed intervals in a string.
                 */
                
            }
            
            Section ("Uniqued") {
                Button("Unique") {
                    let allNumbers = [3, 7, 8, 8, 7, 67, 8, 7, 13, 8, 3, 7, 31]
                    let uniqueNumbers = allNumbers.uniqued().sorted()
                    
                    for number in uniqueNumbers {
                        print("\(number) is a lucky number")
                    }
                }
                Button("Uniqued on") {
                    
                    let destinations = [
                        City(name: "Hamburg", country: "Germany"),
                        City(name: "Kyoto", country: "Japan"),
                        City(name: "Osaka", country: "Japan"),
                        City(name: "Naples", country: "Italy"),
                        City(name: "Florence", country: "Italy"),
                    ]
                    
                    let selectedCities = destinations.uniqued(on: \.country)
                    
                    for city in selectedCities {
                        print("Visit \(city.name) in \(city.country)")
                    }
                }
            }
            
            Section ("Compacted") {
                /*
                 However, compacted() has another important benefit which is that it’s always lazy, as opposed to being lazy only when you request it. So, the work of unwrapping and removing will only happen when you actually use it, which makes it a lot more efficient when you chain operations together.
                 */
                Button("Compacted") {
                    let numbers = [10, nil, 20, nil, 30]
                    let safeNumbers = numbers.compacted()
                    print(safeNumbers.count)
                }
            }
            Section ("Product") {
                /*
                 For example, if we have two arrays of people and games, we could use product() to loop over every combination so that every person gets to play every game:
                 */
                Button("Product") {
                    let people = ["Sophie", "Charlotte", "Maddie", "Sennen"]
                    let games = ["Mario Kart", "Boomerang Fu"]
                    
                    let allOptions = product(people, games)
                    
                    for option in allOptions {
                        print("\(option.0) will play \(option.1)")
                    }
                }
                Button("Product Times Tables") {
                    
                    let range = 1...12
                    let allMultiples = product(range, range)
                    
                    for pair in allMultiples {
                        print("\(pair.0) x \(pair.1) is \(pair.0 * pair.1)")
                    }
                }
                Button("Product Times Tables 20 questions") {
                    let range = 1...12
                    let questionCount = 20
                    let allMultiples = product(range, range).shuffled().prefix(questionCount)

                    for pair in allMultiples {
                        print("\(pair.0) x \(pair.1) is \(pair.0 * pair.1)")
                    }
                }
                /*
                 One slight downside to use product() right now is that it works with only two parameters, meaning that if you need to iterate over several collections then you need to nest your product() calls.
                 */
                Button("Product 3 parameters") {
                let suspects = ["Colonel Mustard", "Professor Plum", "Mrs White"]
                let locations = ["kitchen", "library", "study", "hall"]
                let weapons = ["candlestick", "dagger", "lead pipe", "rope"]
                let guesses = product(product(suspects, locations), weapons)

                for guess in guesses {
                    print("Was it \(guess.0.0) in the \(guess.0.1) with the \(guess.1)?")
                }
                }
            }
            Section ("AdjacentPairs") {
                /*
                 read overlapping subsequences of a sequence, which is great for doing things like calculating moving averages across a sequence.

                 If you just want all neighboring pairs you can use the lazy adjacentPairs() method in an sequence, like this:
                 */
                
                Button("AdjacentPairs") {
                    let numbers = (1...100).adjacentPairs()

                    for pair in numbers {
                        print("Pair: \(pair.0) and \(pair.1)")
                    }
                }
            }
            
            Section ("Windows") {
                /*
                 However, for more advanced uses there’s also a windows(ofCount:) method that lets you control how big your sliding window should be. So, we could make groups of 5 like this:
                 */
                Button("Windows") {
                    let numbers = (1...100).windows(ofCount: 5)

                    for group in numbers {
                        let strings = group.map(String.init)
                        print(ListFormatter.localizedString(byJoining: strings))
                    }
                }
            }
            
            Section ("minAndMax") {
                /*
                 read overlapping subsequences of a sequence, which is great for doing things like calculating moving averages across a sequence.

                 If you just want all neighboring pairs you can use the lazy adjacentPairs() method in an sequence, like this:
                 */
                
                Button("minAndMax") {
                    /*
                     Swift Algorithms comes with enhanced methods for calculating the minimum and maximum values in a sequence. You can provide a custom test if you want, but if your sequence conforms to Comparable you’ll get the default test of <, like this:
                     */
                    
                    let names = ["John", "Paul", "George", "Ringo"]

                    if let (first, last) = names.minAndMax() {
                        print(first)
                        print(last)
                    }
                }
                Button("minAndMax highest and lowest") {
                    /*
                     It also provides methods for reading multiple of the highest and lowest values at the same time, like this:
                     
                     Internally that will sort and prefix or suffix the results if you’re trying to read more than 10% of the whole sequence, but otherwise it uses a faster algorithm – it just does the right thing automatically, like so much of Swift Algorithms.
                     */
                    
                    let scores = [42, 4, 23, 8, 16, 15]
                    let threeLowest = scores.min(count: 3)
                    print(threeLowest)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
