
Topics to cover

- Why are you pestering me? Why are we writing tests?  Yes I know this has been done to death, lets just recap and talk about the mental blocks, my plane anaology.. flight test checks. Be a dummy!!! Test first :-)
- Where do I start? What helped me to get started..  Writing code in smaller chunks.  I stopped writing big jagunda scripts and modules.. Broke them down into smaller parts, then you just test for those one at a time.  Talk about my struggles with Test Driven Development approach..  I came from Science back ground, we tested by experimenting and I want to solve the problem first.. that is just how I am wired.  I guess in the end.. if you are writing tests that work for their intended purpose to me that is what is important.   Start with what you know(what tests to write first) Just need to get started.. this needs to be more about concepts.. talking the whole day won't really help anyone right tests.. going to try and give the most value in a none hands on session.
- Now What? Lets start doing some testing- lets go over some simple basics first just to make sure we are level set for the rest of the session, I don't want to use simple examples but I am just using them to level set some concepts that will help get someone start or get over the "mental" hump that i also suffered.  So the example will cover functions seperately and then as a module.. and a test of the module manifest
- How dare you mock me - Assert-Verfiable Mocks to make sure that the mocks you specify are created. Going to do a unit test and integration test.. the mock function is mostly used in testing the unit tests as we just want to test the code I am writing and not function we are using as example "Get-Service".  Math teacher analogy... You got homework to do problems 1-55 just the odds.  And ofcourse you know the anwers
for the odds are in the back of the book.  So you go an write down just the answers, and then hand
it in.  Teacher says.. nope you failed.  You want to make sure when executing your tests
it actually is hitting your logic.. Make sure it is doing the work.

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







