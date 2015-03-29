---
title: Porting Selecta to Rust
subtitle: What I learned from writing a port
author: Felipe Sere
date: 2015-02-23
---

With the new year I decided it was time to pick up a new language. Having always used high-level languages I decided to try out Rust, a system language.

After getting through the first steps of reading the excellent [Rust guide](http://doc.rust-lang.org/1.0.0-alpha/book/), using [playpen](https://play.rust-lang.org/), writing a kata or two and a toy application, I felt confident enough to push my boundaries. Hence I decided to port [selecta](https://github.com/garybernhardt/selecta) - a fuzzy-matching filter for the command-line written in Ruby - to Rust.

Doing a port would allow me to focus on language specifc aspects rather than solving a specific domain problem. Consider it a larger kata, where you already know the solution and deliberately focus on using the tools at hand.

# Stand on the shoulders of giants

When discussing TDD and code quality, I sometimes hear the question _"Which would you rather keep, your production code or your tests?"_. If you have high-quality tests, you should be able to produce similar code with clean design. Porting `selecta` gave me a chance to put that hypothesis to the test. I started out with a piece of code that was well tested and had few dependencies. In the case of `selecta` it was the main `score` algorithm. From reading the tests it was clear what the function did: given a `choice` string, and a search `query`, it would compute how well the `query` fits the `choice`.

One by one I ported the tests and made them pass. The beauty was that I did not have to worry about finding the next test case as they were already laid out for me. Every bump in the road was a valuable lesson. Either I learned about a new API from the standard library or I learned about a language feature I had not used so far.

# Refactor to make it idiomatic

Once `selecta` was ported it was time to step back and look Rubyisms in my codebase. In my case the algorithm was allocating and manipulating a lot of strings, which is expensive and was hindering it from working on large datasets (_think: 50 000 input strings or more_). One of Rust's strengths is the ability to safely manage memory, which boosts performance without requiring a garbage collector. To measure performance, I set up a suite of benchmarks that were exercising the code in different scenarios. I began looking for ways to reduce the number of string allocations to a bare minimum. Optimally, the program would allocate the input strings exactly once and then only reference that memory. This led me to learn more about Rust's _ownership, borrowing and lifetimes_. Lifetimes are an interesting concept I had not encountered in other languages. When passing pointers around Rust forces you to be explicit about how long those references will be valid. That _lifetime_ is then also applied to the data structures storing those references. The compiler can then ensure that those data structures containing references always point to valid memory.

Another fascinating aspect of Rust is the fact that it has no concept of a _null_ pointer.  Rust's way of expressing _nothingness_ is to use the `Option<T>` enum with its two variations: `Some(T)` and `None`.
Initially, I used _pattern-matching_ to differentiate the two variations for functions that returned optional values.  This is an anti-pattern as the API of `Option<T>` provides many methods that make using an optional value very expressive. For example it has an `unwrap_or(self, other: T)` function that will return the containing value for `Some` or return `other` for `None`. There is even a lazy version `unwrap_or_else(self, f: F)` that takes a function to be evaluated should there be a `None`.  Using these functions appropriately made the code shorter and more expressive by making error handling more concise.

# Make it public

Once I felt comfortable with the port, I published it on GitHub and announced it on Reddit. It received attention from the Rust community, resulting in code suggestions and ideas for improvement. A few tips here and there gave me enough motivation to go and explore more APIs and similar Rust projects.

Porting `selecta` to Rust is what kept me interested in Rust. It was also a good way to introduce myself to the Rust community by presenting working code, requesting feedback and showing willingness to learn.

`icepick`, my port of `selecta` is [here](http://github.com/felipesere/icepick). I invite you to have a look at the code, send feedback via pull requests or issues. Also, I encourage you to port `selecta` to a new language!
