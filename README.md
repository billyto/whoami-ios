Who am I? (iOS Client)
======

A mobile web app built for the [viggle][Viggle] platform. One half of the Who am I? app. Who am I? allows a user to record an impersonation of a character from a TV show. Other users can then watch the resulting video and pick which character they think was referenced. Picking the correct answer will get them Viggle points.

The other half is a Javascript app (Node with Express)  written by [vapp][Teddy Wing] that allows users to  watch the recorded video and guess the character represented.



APIs used:

* [TMS API][tms]

* [Zencoder API][zenc]

* [AWS][aws] (S3)

* [Parse.com][parse]


Other open source components:

* [DMGridView][grid]


Developed at [TVnext Hack 2013.][tvhack]. The app will work after adding the appropiate keys in the app delegate file. 
Please consider the quality of this code as a hackhaton excercise and obviously not ready for production. 


License
-------
Who am I? is licensed under the MIT License.



[viggle]: https://www.viggle.com "Viggle website"
[vapp]: https://github.com/teddywing/Who-am-I "Vapp"
[tvhack]: http://www.tvnexthack.com "TV Next Hack"
[tms]: http://developer.tmsapi.com/  "TMS API"
[zenc]: https://app.zencoder.com/docs/api "Zencoder API"
[aws]: http://aws.amazon.com/sdkforios/ "AWS for iOS"
[parse]: https://parse.com/docs/ios_guide#top/iOS "Parse.com for iOS"
[grid]: https://github.com/gmoledina/GMGridView "GridView component"
