# LG Projects

This was the result of work at the [LG Makers hack day](http://localgovdigital.info/localgov-digital-makers/localgov-makers-2014-hack-day/). You can see the [live code running here](http://lgprojects.herokuapp.com/)

It lists all the repos of UK organisations listed at [https://government.github.com/community/](https://government.github.com/community/). You can then click and view their repos.

As well as listing repos and links, it also optionally looks for a [civic.json](https://github.com/danblundell/civic.json) file within that repo to provide additional context.

## How do I add a civic.json file to my repo?

Take a look at the [schema here](https://github.com/danblundell/civic.json), and add a file in that format. You can see an [example here](https://github.com/Lichfield-District-Council/Ratemyplace/blob/master/civic.json).
The LG Projects bot will then pick it up (it runs daily), and list the additional metadata on the site.

## Future plans

Search would be great! Any other ideas, please add them in the issues, or better still, fork this repo and add a pull request!
