---
title: Using Hamcrest Matchers
date: 2014-10-19
---
Test-driven development has brought the idea of clean, tested design to the masses. There are countless examples of good software written by adhering to tight cycle of *red, green, refactor*.

From my own personal experience, I know that *understanding* that cycle and *adhering* to it is not always easy.

<!-- more -->

Especially if your project was not always driven by tests and there are no *test gurus* around to assist in creating a good test suite. Because let's face it: testing is hard. Not paying attention to details when writing tests will make maintaining your project *and* writing new tests even harder. The pinnacle of that streak of bad tests is that we won't write any new tests at all. Either because it requires too much effort or because we have been stung so many times before.

The good thing is that while that *negative cycle* is true, so is the *positive cycle*: Good tests will attract more good tests and lead to a healthy code base. In this post I want to show you one tool that made that little voice in my head go "Aha!": Hamcrest Matchers.

## What is Hamcrest

Hamcrest (*which is an anagram for 'Matchers'*) is a library of composable matchers which can be plugged into each other. Why bother making it 'composable' and 'pluggable'? Early version of JUnit and provided very primitive tools to test assert statements in our code, mainly `assertTrue(...)` and `assertEquals(...)`. This worked fine and these are the atomic building blocks of the testing language, but they are not sufficiently expressive assertions for your specific domain.

That is where Hamcrest comes in. With its building blocks for matchers, `assertThat(...)` and some syntactic sugar (mostly is(...) ) you can write tests that are close to natural language (*or as close as you can get with Java*). The fact that these matchers are composable means that we can write our own to enhance the expressiveness even more.

## A simple comparison

Below you can see a simple test that checks that the body of an `HttpResponse` contains the string initially passed as query parameters. Take a minute to compare the two assertion lines. The first uses a plain `assertTrue(...)` to check for the existence of 'foo' and 'bar' in the `String` that represents the body. The second uses the newer `assertThat(...)` syntax along side a custom-written `hasBody(..)` matcher.

``` java
@Test
public void returnsQueryParamsInBody() {
  HttpRequest request = request(GET, "/parameters?foo=bar").build();

  Controller controller = new ParameterController();
  HttpResponse response = controller.doGet(request);

  assertTrue(response.getBody().contains("foo") && response.getBody().contains("bar"));
  assertThat(response, hasBody(allOf(containsString("foo"), containsString("bar"))));
}
```



Though the example is pretty small, it does show that using the Hamcrest matchers results in a higher level of abstraction. That also makes the test read well. It does rely on a string comparison, but it is not the main focus of this test.

As we will see later in the post, custom matchers are also highly reusable. If I were to test that the body has a certain length or did not contain a specific bit of text, it would be as easy as plugging in a different matcher.

## Making it your own

So, how do we create such a matcher? There is a base `Matcher<T>` which can be used to create your own matchers. Using that class is very low-level often not necessary. There are two classes which I often use to create matchers: `TypeSafeMatcher<T>` and `FeatureMatcher<T,U>`.

My `hasBody(...)` method is implemented to return a `FeatureMatcher<HttpResponse, String>`. What a FeatureMatcher does is extract a certain feature of the object to check and apply the given matcher to it:

``` java
public static Matcher<HttpResponse> hasBody(Matcher<String> matcher) {
  return new FeatureMatcher<HttpResponse, String>(matcher, "the body to match", "the body did not match" ) {
    @Override
    protected String featureValueOf(HttpResponse actual) {
      return actual.getBody();
    }
  };
}
```


In this case it simply extracts the body and applies any matcher that apply to Strings. There are two string getting passed into the constructor of the FeatureMatcher. The first string - *the body to match* - is what will be output as part of the expectation if a matcher fails. The second string - *the body did not match* - will be displayed as part of the actual object. Don't bother all too much in getting a perfect english sentence into these, as combining the matchers doesn't line up perfectly with the english language.

*See below in the Appendix for an example of a TypeSafeMatcher*

## Growing into it

Hamcrest matcher are great and provide a great amount of flexibility and expressiveness. Yet, they are not my first choice when improving the readability of my tests. I start out with simple language constructs that I can use without bringing in libraries or having to create classes. Hence, my first approach is to simply extract a method. For the above case, that method started out looking like this:

``` java
public String bodyOf(HttpResponse response) {
  return response.getBody();
}
```


This method accomplishes almost the same as the above described FeatureMatcher. When writing my tests using like this give you most of the legibility benefit without the overhead. Now, once I either use these methods across multiple test classes, they are not flexible enough or my assertions start to leak too much implementation, I switch over to Hamcrest matchers. The way I do that is to collect my matchers by what they apply to and create a class with static methods for it. A nice benefit is that I get a nice overview of the things I am interested in testing. If I don't have a matcher for either a public method or field, I start thinking about removing it.

## Conclusion

Have a look at the Hamcrest matchers and get used to writing your own. You don't have to reinvent many of them. Sometimes it even helps to just wrap them to rename them to match the domain you are working. And please please please look after your tests! They are just as important as your production code and should be treated as first-class code.

# Appendix

A simple Matcher to check that specific combination of HttpHeader key and value exist in the response:

``` java
public static Matcher<HttpResponse> hasHeader(String header, String value) {
  return new TypeSafeMatcher<HttpResponse>() {
    @Override
    protected boolean matchesSafely(HttpResponse item) {
      Map<String, String> responseHeaders = item.getHeader();
      if(responseHeaders.containsKey(header)) {
        return responseHeaders.get(header).equals(value);
      }
      return false;
    }

    @Override
    public void describeTo(Description description) {
    }
  };
}
```
