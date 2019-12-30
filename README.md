# storyApp

How To sync ?


** we are storing client updated/created time, but we should not rely on them for syncing on client side, as client time may not be accurate, so we will be only relying on server time. we will be storing "lastRequestedSererTime" locally.
**

1.a) Whenever Internet is Available: first we need to first sync data from server. while requesting data from server you can pass "lastRequestedServerTime" (which is server time and we will be storing  locally). So that server will return only those data which are updated since last time (as there is no need to return all data). sync server data into local db. (data from server may looks like...
{
    {
        inserts:
        [
            {
                storyId: AAAAAA
                storyTitle: this is a new story....
                story description: this is story desrition of story1...
            },
            {
                storyId: BBBB
                storyTitle: this is B story....
                story description: this is story desrition of storyB...
            }
        ]
    }
    {
        updates:
        [
            {
                storyId: CCCCC
                storyTitle: this is a new story.... // only story title updated..., 
            },
            {
                storyId: BBBB
                story description: this is story description of storyC... // only description updated.
            }
        ]
    }
    {
        deletes:
        [
            {
                storyId: ZZZZZ // delete this story locally, if there is no update locally. if there is an local update too then ask user a choice.
            }
        ]
    }
}
        
}

** what if you are working on a story locally(offline) and if same story is deleted/modified from server by someone else? Now suppose internet become available, if you sync it from server it will be also deleted/modified locally. But you can give user a choice, Do you want to keep versionA or versionB? if user choose to keep A or B then, next time when we sync local data to server, we will also send this change to server.

**after syncing records from server to client ***
1) mark them as Unchanged (if there is no local changes related to same records)


 ** syncing data from client to server **
 
 for each of story, we can store its states (just an integer value 1 to 4)
 1) Unchanged. (when user don't perform any change on story locally)
 2) Deleted.(when user deletes story locally)
 3) Updated. (when user updates story locally)
 4) Added. (when user adds new story locally)

**** while sycing records from client to server *****
we can check collect only those stories whose status != Unchanged.


*** how to identify story uniquely ***
with UUID. (although having big uuid as primary key gives you poor performance. as search time complexity : O(n)
 another alternative way is, assigning temp id to client story and then getting permenant story id from server later on and update locally, but that will require more handling..) in this case search time complexity can be improved with O(logn).


 
