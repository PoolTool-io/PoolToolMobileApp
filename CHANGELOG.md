## Unreleased

### Fix

- handle Maps or lists of data from backend
- remove chat ready filter and add retired pools filter
- make verificationDate not required
- add explanation text on forgot password screen

### Refactor

- replace depreciated DioError with DioException
- use new Html API

## 3.21.1 (2023-03-18)

### Fix

- check for null blocks in sorting pools
- add observer for app lifecycle state changes and refresh pools on resume

### Refactor

- add persistence cache size
- use new stream subscription for stake pools updated and move setup pools state to own method
- add stream controller for when stake pools updated and move setup featured pools to own method

## 3.21.0 (2023-03-11)

### Feat

- add pull down to refresh favourites

### Fix

- update favourite pools when data update
- update build files
- project build files update
- from allow_blank_pool_groups
- handle missing values after epoch change
- make HiveService disposable

## 3.20.0 (2023-02-17)

## 1.2.0 (2023-02-17)

### Feat

- add displayName function to StakePool model
- add alerts for pool pledge

### Fix

- improve performance of stake pools and favorites screens
- handle pool with no blocks
- remove Flutter restart_app and use navigate to home
- remove late from stream subscriptions
- move stake history list to getStakeHist method
- remove chat
- check if myAddress is just a bool
- remove BroughtToYouByWidget
- reverse null check for block list
- check length of delegators to set range
- use StakePool model to fix filtering
- check type of pool.c if bool to fix loading pools
- fix login and other updates
- handle notifications tap to navigate to pool
- improve theme contrasts
- fix saturation alert
- remove leader column on blocks widget
- add necessary fields
- improve epoch service
- remove type coercion
- add repository calls for all blocks page
- use add to list instead of insert
- use broadcast streams and fix favorite pools
- remove unused print

### Refactor

- migrate to latest Flutter API
- remove use of global variables for services
- move blocks widget to folders
- use MyAddress model
- remove user and use services
- add AccountWidgets as new widget
- use firebaseAuthService
- add my address repository and models
- remove unused changelog
- add Dio delegators client for data from s3
- add models for delegators from s3
- add constants for alerts
- move block list header to widget
- use new alerts repositories and separate pool pledge details for pledge alerts
- add new repositories and services
- add alert repositories
- add FirebaseMessagingService service
- add models for alerts
- use models for strong typing style: fix linting issues
- use models in utils
- add PoolStatsRepository and EcosystemRepository to services
- update models
- add getStakePools to StakePoolsRepository
- add PoolStatsRepository
- add EcosystemRepository
- add SATURATION_INFO to Constants
- add necessary EpochRepository and PoolBlocksNeRepository
- add pool blocks ne repository
- add epoch repository and models
- rename class
- use stake history repository
- use mary db sync status repository
- add getMaryDbSyncStatus to mary db sync status repository
- use stake pool model and constants
- use renamed theme_provider in test
- add chart data model
- add stake history repository
- add epoch length constant
- use maryDbSyncStatusRepository in EpochService
- use stake pool model in favorites style: fix linting issues
- remove epoch service from MaryDbSyncStatusRepository
- add stake_pools model
- add stake_pools repository
- initialize services from config services and other code cleanup and improvements
- use constants in local database
- use constants userIdPreference style:  name source files using `lowercase_with_underscores`
- use constants in theme provider
- add file to init services
- add file for constants
- add insert in order method
- move sort enum to own file
- make codebase Null Safe
