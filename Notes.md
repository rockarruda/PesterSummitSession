
Topics to cover

Hi my name is Jim Arruda... well that is enough about me, lets get started!!!

## **Intro**
 - I came from a System Admin background and not of one of a developer.  So I am not "formally" trained in coding and etc so don't be making fun of my code!!  Last year hear at the summit I wanted to find more out about how to get started or what helps getting started with using Pester.  I had talked with some people for tips on how to get started or how to break the mental block of "getting time" to do it, when you just want to get something out now.  Since I am not a developer, my experience isn't as decorated, so that made a little bit more of a struggle to get started.  But after all we are all here because it is a community, and I may not know everything but I am willing to share what I do know and hopefully you will find it helpful to you, if you also are struggling or have struggled with this topic.

## **Why Are You Pestering Me?**
- Why are you pestering me? Why are we writing tests?  Yes I know this has been done to death, lets just recap and talk about the mental blocks, what made this dificult for me to start doing... my plane analogy.. flight test checks. Car crash dummies...Be a dummy!!! Test first :-)
 
- Time, in my role I usually need something NOW or yesterday, and this usually occurs ALOT, so once you get one problem solved or script written you have to go on to the next.  That does make it difficult to now INVEST in testing.  And I chose my word carefully there, INVEST, yes it takes time to write tests, but if you follow a few other principles that I wasn't at first myself, it will help midigate how much time you need to invest.

 




## **Where do I start?**
- What helped me to get started..  Writing code in smaller chunks.  I stopped writing big jagunda scripts and modules.. Broke them down into smaller parts, then you just test for those one at a time.  Talk about my struggles with Test Driven Development approach..  I came from Science back ground, we tested by experimenting and I want to solve the problem first.. that is just how I am wired.  I guess in the end.. if you are writing tests that work for their intended purpose to me that is what is important.   Start with what you know(what tests to write first) Just need to get started.. this needs to be more about concepts.. talking the whole day won't really help anyone right tests.. going to try and give the most value in a none hands on session.


## **Now What?**
- Lets start doing some testing- lets go over some simple basics first just to make sure we are level set for the rest of the session, I don't want to use simple examples but I am just using them to level set some concepts that will help get someone start or get over the "mental" hump that i also suffered.  So the example will cover functions seperately and then as a module.. and a test of the module manifest.. use passthrough to obatain outputs.  Also include testing a module once I have that completed.. Manifest test and etc..


## **How dare you mock me**
 -  Going to do a unit test and integration test.. the mock function is mostly used in testing the unit tests as we just want to test the code I am writing and not function we are using as example "Get-Service".  Math teacher analogy... You got homework to do problems 1-55 just the odds.  And ofcourse you know the anwers for the odds are in the back of the book.  So you go an write down just the answers, and then hand it in.  Teacher says.. nope you failed.  You want to make sure when executing your tests
it actually is hitting your logic.. Make sure it is doing the work.  New-MockObject.. I was going to use that to show you can mock an object type, but the type I was mocking didn't allow the manipulation of the properties. Assert-Verfiable Mocks to make sure that the mocks you specify are created.

Then use the local octopus server tests to mock the rest api and invoke-restmethod command which is something a lot of us are using more regularly

Show simple example of the mock (Get-Token Test) .. show the coverage output not covering the code in the ps1 which shows the mock actually worked.. then comment it out then re-run now you will see the code has worked.


#- Basics of Pester
#- Simple Functions (Like simple simple)
#- Real World application
#- Simple Module
#- Mocking - more complex functions with remote commands or interacting with Rest APIs
- 

Work the tests backwards.. you know what the answer should be, you know what has to be done to get it..
start with that.  start with what you know.

You know what the script/function is going to do, you expect what it should return... Start with that..

Will it test 100% over everything?  No....  Is it testing something.. Yes...

You don't have to have EVERYTHING done before you begin.

#Do a Pester test for presentation?  For fun??

Sys Admins - Pester tests for system checks, Testing DSC resources?

Unit Tests and Integration tests?

Resources I used:

https://www.youtube.com/watch?v=jvvh9cpD_LM - June Blender (Test Driven development with Pester 2016)

https://github.com/pester/Pester - Pester Git hub site with links to further help on using pester.

https://github.com/pester/Pester/wiki = Pester Wiki with references to operators and other functions of Pester.







