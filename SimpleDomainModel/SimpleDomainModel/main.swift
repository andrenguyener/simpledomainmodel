//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var amount = 0
    
    switch (self.currency, to) {
    case ("USD", "GBP"):
        amount = self.amount / 2
    case("USD", "EUR"):
        amount = Int(Double(self.amount) * 1.5)
    case("USD", "CAN"):
        amount = Int(Double(self.amount) * 1.25)
    case("GBP", "USD"):
        amount = self.amount * 2
    case("EUR", "USD"):
        amount = Int(Double(self.amount) / 1.5)
    case("CAN", "USD"):
        amount = Int(Double(self.amount) / 1.25)
    default:
        amount = self.amount
    }
    
    return Money(amount: amount, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    let newAmount : Int = self.convert(to.currency).amount + to.amount
    return Money(amount: newAmount , currency: to.currency)
  }
    
  public func subtract(_ from: Money) -> Money {
    let newAmount : Int = self.amount - from.convert(self.currency).amount
    return Money(amount: newAmount, currency: self.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let hour):
        return Int(hour * Double(hours))
    case .Salary(let salary):
        return salary
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let hour):
        self.type = .Hourly(hour + amt)
    case .Salary(let salary):
        self.type = .Salary(salary + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return self._job }
    set(value) {
        self._job = self.age > 16 ? value : nil
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return self._spouse}
    set(value) {
        self._spouse = self.age > 18 ? value: nil
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job ?? nil) spouse:\(self.spouse)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.spouse == nil && spouse2.spouse == nil) {
        self.members.append(spouse1)
        self.members.append(spouse2)
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if members[0].age >= 21 || members[1].age >= 21 {
        members.append(child)
        return true
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var sum = 0
    for person in self.members {
        if ((person.job?.calculateIncome(2000)) != nil) {
            sum += (person.job?.calculateIncome(2000))!
        }
    }
    return sum
  }
}





