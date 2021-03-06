#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GTLCalendar.h"
#import "GTLCalendarAcl.h"
#import "GTLCalendarAclRule.h"
#import "GTLCalendarCalendar.h"
#import "GTLCalendarCalendarList.h"
#import "GTLCalendarCalendarListEntry.h"
#import "GTLCalendarChannel.h"
#import "GTLCalendarColorDefinition.h"
#import "GTLCalendarColors.h"
#import "GTLCalendarConstants.h"
#import "GTLCalendarError.h"
#import "GTLCalendarEvent.h"
#import "GTLCalendarEventAttachment.h"
#import "GTLCalendarEventAttendee.h"
#import "GTLCalendarEventDateTime.h"
#import "GTLCalendarEventReminder.h"
#import "GTLCalendarEvents.h"
#import "GTLCalendarFreeBusyCalendar.h"
#import "GTLCalendarFreeBusyGroup.h"
#import "GTLCalendarFreeBusyRequestItem.h"
#import "GTLCalendarFreeBusyResponse.h"
#import "GTLCalendarNotification.h"
#import "GTLCalendarSetting.h"
#import "GTLCalendarSettings.h"
#import "GTLCalendarTimePeriod.h"
#import "GTLQueryCalendar.h"
#import "GTLServiceCalendar.h"
#import "GTLDefines.h"
#import "GTLBatchQuery.h"
#import "GTLBatchResult.h"
#import "GTLDateTime.h"
#import "GTLErrorObject.h"
#import "GTLObject.h"
#import "GTLQuery.h"
#import "GTLRuntimeCommon.h"
#import "GTLService.h"
#import "GTLUploadParameters.h"
#import "GTLBase64.h"
#import "GTLFramework.h"
#import "GTLJSONParser.h"
#import "GTLTargetNamespace.h"
#import "GTLUtilities.h"

FOUNDATION_EXPORT double GoogleAPIClientVersionNumber;
FOUNDATION_EXPORT const unsigned char GoogleAPIClientVersionString[];

