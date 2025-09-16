// API URL constants for all ShabadGuru API endpoints
class ApiUrl {
  static const popularBannisUrl = "https://shabad-guru.org/api/popular-banis"; // Popular Banis endpoint
  static const popularRaagsUrl = "https://shabad-guru.org/api/raags"; // Popular Raags endpoint
  static const shabadUrl = "https://shabad-guru.org/api/raags/"; // Specific Shabad endpoint (requires categoryId/id)
  static const contactUsUrl = "https://shabad-guru.org/api/contact/us"; // Contact us form submission endpoint
  static const theKirtanisUrl = "https://shabad-guru.org/api/kirtanis/images"; // The Kirtanis images endpoint
  static const emailSubscribeUrl = "https://shabad-guru.org/api/subscriber"; // Email subscription endpoint
  static const uploadPushNotificationToken = "https://shabad-guru.org/api/pushnotification"; // Push notification token upload endpoint
  static const updatePermission = "https://shabad-guru.org/api/pushnotification/permission"; // Notification permission update endpoint
}