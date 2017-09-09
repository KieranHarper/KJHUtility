//
//  KJHUtilityTests.swift
//  KJHUtility
//
//  Created by Kieran Harper on 9/9/17.
//  Copyright © 2017 KJHUtility. All rights reserved.
//

import Quick
import Nimble
import KJHUtility

class KJHUtilitySpec: QuickSpec {
        
    override func spec() {

        // For more information about Quick and Nimble:
        // https://github.com/Quick/Quick
        // https://github.com/Quick/Nimble

        // EXAMPLES:
        
        describe("A bunch of numbers") {
            it("should add up") {
                expect(1 + 1).to(equal(2))                
            }
            it("should behave logically") {
                expect(1.2).to(beCloseTo(1.1, within: 0.1))
                expect(3) > 2
            }
        }

        describe("Some other stuff") {
            it("should make sense") {
                expect("seahorse").to(contain("sea"))
                expect(["Atlantic", "Pacific"]).toNot(contain("Mississippi"))
            }
        }
    }
}
