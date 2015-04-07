---
title: Ripples In Abstractions
subtitle: When things go gently wrong
author: Felipe Sere
date: 2014-10-23
---
Small changes in parts of your application can have an effect on distant components. This is not always necessarily bad. But if we feel we could have avoided that ripple, we are missing an abstraction. Now, It is important to know when to make a tradeoff, either because the more general solution would be overly complex or because the change we are trying to protect against might never materialize. So not all abstractions are great or even necessary.

For this blog I want to explore the effects of making the size of my TicTacToe board user-selectable.

# The approach

I decided to approach this change inside-out: I would begin by making my `Board` capable of accepting a variable board size, then proceed to make the UI capable of displaying it and finally make the user able to choose a size. Whatever broke along the way would be fixed then and there.

## Incomplete abstractions

The very first change was relatively trivial: I added a new constructor to my `Board` and had the current constructor call that. Adding a test that would assert that a `Board` with side-size of 4 would have 16 possible moves gave me my first place to start changing the code.

The code below show my abstraction for a `Line` on a `Board`. It hides away which direction the line is in. The problem with this little class is that even though it looks like a sound abstraction, there is a flaw that allows the the underlying datastrucure to leak:

~~~ java
class Line {
  private final PlayerMark first;
  private final PlayerMark second;
  private final PlayerMark third;

   public Line(List<PlayerMark> elements){
     first  = elements.get(0);
     second = elements.get(1);
     third  = elements.get(2);
   }

   public boolean hasWinner() {
     ...
   }

   private boolean allSame() {
     ...
   }

   public boolean isWinner(PlayerMark player) {
     ...
   }
}
~~~

Though the constructor accepts a `List<PlayerMark>`, it assigns the values to three individual fields. This breaks the abstraction, because the individual fields are less expressive than the list (they don't scale in size). The solution to this is simple: Change three individual fields into a list and adjust the method accordingly.

T    his is a simple example where a client of this class can reasonably expect flexibility, but is faced with odd behaviour when used with an unexpected input (*anything other than exactly 3 elements*). The underlying datastructure leaked to the outside world.

# Simplicity vs. Generality

The next bit that broke was the fact that even though the `Line` was not generic enough to contain any amount of `PlayerMarks`, it was not getting more than three. Spotting the reason for that was trivial. Just have a look at these three methods:

~~~ 
use score::Match;

#[derive(PartialEq, Debug)]
pub enum Text<'a> {
  Colored(Match<'a>),
    Normal(String),
    Highlight(String),
    Blank,
}

impl<'a> Text<'a> {
  pub fn printable(self) -> String {
    match self {
      Text::Normal(t) => t,
        _ => "fail".to_string(),
    }
  }
}
~~~

These three methods are hardcoded against the size of the board. This is where putting in the right abstraction or *formula* to calculate rows and columns comes into play and is, in my eyes, debatable. Sure, hardcoding these values means they will not accept any kind of change, but adding the proper function for rows, columns and diagonals without having a flexibile size is pointless. It makes the code harder to read and understand does not benefit it immediately.

So I went ahead and added the proper functions:

~~~ ruby
class Coinchanger
  COINS = [50, 20, 10, 5,2, 1]

  def self.change_for(amount)
    change = []

    COINS.each do |coin|
      while amount >= coin
        change << coin
        amount -= coin
      end
    end

    change
  end
end
~~~


If asked to write TicTacToe again, I would do this all over. Although I do see the value in having this scalable, it simply does not carry its own weight without flexible board sizes. This is the case of a premature abstraction which should be avoided as much as a missed abstractions.

# A view of the data

The next part that did not support flexible board sizes was the actual *visualisation* of the board in the console. The first version did nothing clever about the size and just replaced numbers in a template. The problem is that that template was hardcoded.

Handling this issue elegantly is hard. We are not interested in the abstract concept of a board and what we can do with it or what we can ask it. We care about the underlying structure and how to represent it to the user. Well, that is not entirely true. There is a certain level of abstraction we could try to fulfil. The user has a predefined notion of what a board looks like. Probably rectangular with Xs where X played and Os for the opponent. What makes this hard is that we have to translate from our internal board into such a "UX board", and do so without binding to tightly to our internal datastrucutre.

And here is some random Clojure:

~~~ clojure
(ns pinaclj.quote-transform
 (:require [net.cgrand.enlive-html :as html]))

(defn- blank? [ch]
 (or (nil? ch) (Character/isWhitespace ch) (= \> ch)))

(defn- replace-quote [next-char last-char]
  (cond
    (and (= \' next-char) (blank? last-char)) "&lsquo;"
    (= \' next-char) "&rsquo;"
    (and (= \" next-char) (blank? last-char)) "&ldquo;"
    :else "&rdquo;"))

(defn- quote-char? [ch]
 (or (= \' ch) (= \" ch)))
~~~

The way I decided to solve this is to make two informations available on the board:

*   The width of the board (*always assume the board to be a square*)
*   A Map which translates board positions to either X, O or EMPTY

That is sufficient to build a dynamic template which adjusts to the size.

# Changing assumptions

There is one more bit of interesting bit of refactoring I had to make to get this to work. Before going the 4x4 route, I could always create boards without really caring. The board always had the same size, so I could create right before I need it. Specifically, my `Game` would create a Board just in time for the players to play on. But what size should it be now? 3x3 or 4x4? That dependency now has to be injected, which messes with quite a few method signatures which in turn ripple to the tests and the callers of those methods.

Though the refactoring is easy, it is one I feel you can not guard against. Someone has to create those objects and without having any constraints you'll put those objects close to their usage. That makes sense from a cognitive perspective.
Once creating those objects then and there makes no more sense, you'll have to connect the *creator* of the object to the *user* of that object.
There are certain patterns to make this less obtrusive like a `Context` which is nothing but a bag for objects which gets passed around, I dont particularly like this. At least not in Java. It feels like I am loosing information there. I am only supposed to pull out *the right* objects out of that bag and simply assume they will be there. In Ruby this is perfectly normal and I use it there myself with a hash as parameters. The difference is that in Ruby I dont loose any information (*there was no type information to begin with*) but in Java I do. You'll see it when using a context combined with a dreaded typecast.

# Conclusion

Let's sum up what we have seen so far.

*   Abstractions have to be consistent. The way you implement an abstraction has to match the interface you expose.
*   Not all abstractions are necessary. Abstractions guard you against change. If no change is foreseeable, don't overcomplicate your codebase with a pointless abstraction
*   You can't guard against every kind of change using an abstraction. Trying to force abstractions will lead to highly-decoupled, but obfuscated code.

Getting your abstractions right is hard there are no simple rules to get it right. In essence, an abstraction only captures the pieces of information relevant to that thought process or algorithm. Take a `Line`, an abstraction for either a row, column or diagonal. Do you care whether this `Line` is a row, column or diagonal? Do you really care about the elements in that row or does your algorithm care that there is a winner? If you manage to write your programs in such a way that you don't care about the details, your application will be much safer against these details changing.
