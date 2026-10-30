// UI string catalog. `en` is the source of truth; additional locales add
// entries under their own key. Keys are flat and namespaced per component.
// A missing key in any locale is a type error against messages.en.
export const messages = {
  en: {
    'app.titleFallback': 'AsyncAPI document',
    'app.filterPlaceholder': 'Filter…',
    'app.filterAria': 'Filter sections',
    'app.switchLocale': 'Switch locale',

    'nav.overview': 'Overview',
    'nav.servers': 'Servers',
    'nav.channels': 'Channels',
    'nav.operations': 'Operations',
    'nav.messages': 'Messages',
    'nav.sections': 'Sections',

    'overview.heading': 'Overview',
    'overview.termsOfService': 'Terms of service',

    'channels.address': 'Address:',

    'servers.heading': 'Servers',
    'servers.noMatch': 'No servers match the filter.',

    'channels.heading': 'Channels',
    'channels.noMatch': 'No channels match the filter.',

    'operations.heading': 'Operations',
    'operations.noMatch': 'No operations match the filter.',

    'messages.heading': 'Messages',
    'messages.noMatch': 'No messages match the filter.',
    'messages.contentType': 'Content type:',
  },

  ar: {
    'app.titleFallback': 'وثيقة AsyncAPI',
    'app.filterPlaceholder': 'تصفية…',
    'app.filterAria': 'تصفية الأقسام',
    'app.switchLocale': 'تبديل اللغة',

    'nav.overview': 'نظرة عامة',
    'nav.servers': 'الخوادم',
    'nav.channels': 'القنوات',
    'nav.operations': 'العمليات',
    'nav.messages': 'الرسائل',
    'nav.sections': 'الأقسام',

    'overview.heading': 'نظرة عامة',
    'overview.termsOfService': 'شروط الخدمة',

    'channels.address': 'العنوان:',

    'servers.heading': 'الخوادم',
    'servers.noMatch': 'لا توجد خوادم مطابقة للتصفية.',

    'channels.heading': 'القنوات',
    'channels.noMatch': 'لا توجد قنوات مطابقة للتصفية.',

    'operations.heading': 'العمليات',
    'operations.noMatch': 'لا توجد عمليات مطابقة للتصفية.',

    'messages.heading': 'الرسائل',
    'messages.noMatch': 'لا توجد رسائل مطابقة للتصفية.',
    'messages.contentType': 'نوع المحتوى:',
  },
} as const

export type Locale = keyof typeof messages
export type MessageKey = keyof typeof messages.en
