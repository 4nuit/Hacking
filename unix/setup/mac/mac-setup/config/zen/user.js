//
/* You may copy+paste this file and use it as it is.
 *
 * If you make changes to your about:config while the program is running, the
 * changes will be overwritten by the user.js when the application restarts.
 *
 * To make lasting changes to preferences, you will have to edit the user.js.
 */

/****************************************************************************
 * Betterfox                                                                *
 * "Ad meliora"                                                             *
 * version: 133                                                             *
 * url: https://github.com/yokoffing/Betterfox                              *
****************************************************************************/

/****************************************************************************
 * SECTION: FASTFOX                                                         *
****************************************************************************/
/** GENERAL ***/
user_pref("content.notify.interval", 100000);

/** GFX ***/
user_pref("gfx.canvas.accelerated.cache-items", 32768); // was 4096 - raised per your overrides
user_pref("gfx.canvas.accelerated.cache-size", 4096); // was 512 - raised per your overrides
user_pref("gfx.content.skia-font-cache-size", 80); // was 20 - raised per your overrides

/** DISK CACHE ***/
user_pref("browser.cache.disk.enable", true);

/** MEDIA CACHE ***/
user_pref("media.memory_cache_max_size", 1048576); // was 65536 - raised per your overrides
user_pref("media.cache_readahead_limit", 9000); // was 7200 - raised per your overrides
user_pref("media.cache_resume_threshold", 6000); // was 3600 - raised per your overrides

/** IMAGE CACHE ***/
user_pref("image.mem.decode_bytes_at_a_time", 131072); // was 32768 - raised per your overrides

/** NETWORK ***/
user_pref("network.http.max-connections", 1800);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);
user_pref("network.http.pacing.requests.enabled", false);
user_pref("network.dnsCacheExpiration", 3600);
user_pref("network.ssl_tokens_cache_capacity", 32768); // was 10240 - raised per your overrides

/** SPECULATIVE LOADING ***/
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("network.prefetch-next", false);
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);

/** EXPERIMENTAL ***/
user_pref("layout.css.grid-template-masonry-value.enabled", true);
user_pref("dom.enable_web_task_scheduling", true);

/****************************************************************************
 * SECTION: SECUREFOX                                                       *
****************************************************************************/
/** TRACKING PROTECTION ***/
user_pref("browser.contentblocking.category", "strict");
user_pref("urlclassifier.trackingSkipURLs", "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com");
user_pref("urlclassifier.features.socialtracking.skipURLs", "*.instagram.com, *.twitter.com, *.twimg.com");
user_pref("browser.download.start_downloads_in_tmp_dir", true);
user_pref("browser.helperApps.deleteTempFileOnExit", true);
user_pref("browser.uitour.enabled", false);
user_pref("privacy.globalprivacycontrol.enabled", true);

/** OCSP & CERTS / HPKP ***/
user_pref("security.OCSP.enabled", 0);
user_pref("security.remote_settings.crlite_filters.enabled", true);
user_pref("security.pki.crlite_mode", 2);

/** SSL / TLS ***/
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("browser.xul.error_pages.expert_bad_cert", true);
user_pref("security.tls.enable_0rtt_data", false);

/** DISK AVOIDANCE ***/
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("browser.sessionstore.interval", 60000);

/** SHUTDOWN & SANITIZING ***/
user_pref("browser.privatebrowsing.resetPBM.enabled", true);
user_pref("privacy.history.custom", true);

/** SEARCH / URL BAR ***/
user_pref("browser.urlbar.trimHttps", true);
user_pref("browser.urlbar.untrimOnUserInteraction.featureGate", true);
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);
user_pref("browser.urlbar.update2.engineAliasRefresh", true);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.quicksuggest.enabled", false);
user_pref("browser.urlbar.groupLabels.enabled", false);
user_pref("browser.formfill.enable", false);
user_pref("security.insecure_connection_text.enabled", true);
user_pref("security.insecure_connection_text.pbmode.enabled", true);
user_pref("network.IDN_show_punycode", true);

/** HTTPS-FIRST POLICY ***/
user_pref("dom.security.https_first", true);

/** PASSWORDS ***/
user_pref("signon.formlessCapture.enabled", false);
user_pref("signon.privateBrowsingCapture.enabled", false);
user_pref("network.auth.subresource-http-auth-allow", 1);
user_pref("editor.truncate_user_pastes", false);

/** MIXED CONTENT + CROSS-SITE ***/
user_pref("security.mixed_content.block_display_content", true);
user_pref("pdfjs.enableScripting", false);

/** EXTENSIONS ***/
user_pref("extensions.enabledScopes", 5);

/** HEADERS / REFERERS ***/
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

/** CONTAINERS ***/
user_pref("privacy.userContext.ui.enabled", true);

/** SAFE BROWSING ***/
user_pref("browser.safebrowsing.downloads.remote.enabled", false);

/** MOZILLA ***/
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.geo", 2);
user_pref("browser.search.update", false);
user_pref("permissions.manager.defaultsUrl", "");

/** TELEMETRY ***/
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

/** EXPERIMENTS ***/
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

/** CRASH REPORTS ***/
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);

/** DETECTION ***/
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);
user_pref("network.connectivity-service.enabled", false);

/****************************************************************************
 * SECTION: PESKYFOX                                                        *
****************************************************************************/
/** MOZILLA UI ***/
user_pref("browser.privatebrowsing.vpnpromourl", "");
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.profiles.enabled", true);

/** THEME ADJUSTMENTS ***/
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.privateWindowSeparation.enabled", false); // WINDOWS

/** COOKIE BANNER HANDLING ***/
user_pref("cookiebanners.service.mode", 1);
user_pref("cookiebanners.service.mode.privateBrowsing", 1);

/** FULLSCREEN NOTICE ***/
user_pref("full-screen-api.transition-duration.enter", "0 0");
user_pref("full-screen-api.transition-duration.leave", "0 0");
user_pref("full-screen-api.warning.timeout", 0);

/** URL BAR ***/
user_pref("browser.urlbar.suggest.calculator", true);
user_pref("browser.urlbar.unitConversion.enabled", true);
user_pref("browser.urlbar.trending.featureGate", false);

/** NEW TAB PAGE ***/
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showWeather", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

/** POCKET ***/
user_pref("extensions.pocket.enabled", false);

/** DOWNLOADS ***/
user_pref("browser.download.manager.addToRecentDocs", false);

/** PDF ***/
user_pref("browser.download.open_pdf_attachments_inline", true);

/** TAB BEHAVIOR ***/
user_pref("browser.bookmarks.openInTabClosesMenu", false);
user_pref("browser.menu.showViewImageInfo", true);
user_pref("findbar.highlightAll", true);
user_pref("layout.word_select.eat_space_to_next_word", false);

/****************************************************************************
 * START: MY OVERRIDES                                                      *
****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/wiki/Common-Overrides
// visit https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening
// Enter your personal overrides below this line:

/** STARTUP & PAINT ***/
user_pref("nglayout.initialpaint.delay", 0); // no delay before first page paint (render ASAP)
user_pref("nglayout.initialpaint.delay_in_oopif", 0); // same, for out-of-process iframes
user_pref("browser.startup.preXulSkeletonUI", false); // skip the pre-rendered startup skeleton window (WINDOWS)
// NOTE: content.notify.interval, gfx.canvas.accelerated.cache-items/cache-size,
// gfx.content.skia-font-cache-size, image.mem.decode_bytes_at_a_time,
// media.memory_cache_max_size, media.cache_readahead_limit, media.cache_resume_threshold,
// network.http.max-connections, network.http.max-persistent-connections-per-server, and
// network.ssl_tokens_cache_capacity already exist above in FASTFOX and were updated in place
// to your values (no duplicates).

/** GFX / WEBRENDER / GPU (reverted to working values - do NOT force software) ***/
// Forcing software rendering via config crashed Zen at boot. These are reset to
// their normal hardware-accelerated values. To turn hardware acceleration OFF,
// use the Settings UI (about:preferences > Performance), NOT these prefs.
user_pref("gfx.webrender.software", false); // do NOT force software WebRender (this was the crash cause)
user_pref("layers.acceleration.disabled", false); // do NOT disable compositor acceleration (this was the crash cause)
user_pref("gfx.webrender.all", true); // normal WebRender GPU path
user_pref("gfx.webrender.precache-shaders", true); // precompile shaders to avoid first-use stutter
user_pref("gfx.webrender.compositor", true); // native OS compositor with WebRender
user_pref("layers.gpu-process.enabled", true); // dedicated GPU process
user_pref("gfx.canvas.accelerated", true); // GPU-accelerated 2D canvas
user_pref("media.hardware-video-decoding.enabled", true); // GPU video decode

/** IMAGE CACHE ***/
user_pref("image.cache.size", 10485760); // max decoded-image cache in bytes (~10 MB)
user_pref("image.mem.shared.unmap.min_expiration_ms", 120000); // keep decoded images in memory longer (2 min)

/** MEDIA CACHE ***/
user_pref("media.memory_caches_combined_limit_kb", 2560000); // combined media memory-cache cap (~2.5 GB)

/** MEMORY CACHE ***/
user_pref("browser.cache.memory.max_entry_size", 0); // 0 = no per-entry size cap for the memory cache

/** NETWORK BUFFERS ***/
user_pref("network.buffer.cache.size", 262144); // larger per-read network buffer (256 KB)
user_pref("network.buffer.cache.count", 128); // more cached network buffers

/****************************************************************************
 * SECTION: ZEN EFFICIENCY GUIDE                                            *
 * Community memory/performance/battery tweaks for Zen Browser.             *
 * (Steps requiring extensions or the Settings UI are not config prefs and *
 *  are not included here: Auto Tab Discard, enhanced-h264ify, hardware-   *
 *  acceleration toggle, about:processes, and setting                      *
 *  zen.tab-unloader.timeout-minutes to your preferred idle window.)       *
****************************************************************************/
/** CORE PERFORMANCE & MEMORY ***/
user_pref("browser.newtab.preload", false); // don't pre-render blank new-tab tiles in the background
user_pref("media.suspend-bkgnd-video.enabled", true); // pause video rendering in background tabs (audio keeps playing)
user_pref("widget.gtk.rounded-bottom-corners.enabled", false); // LINUX: stop custom window rounding (idle CPU spikes)
// user_pref("ui.prefersReducedMotion", 1); // force reduced motion in UI and sites (fewer animations)
user_pref("browser.sessionhistory.max_total_viewers", 0); // don't keep closed pages "alive" in RAM (use 1 for some fast back-nav)
// NOTE: browser.cache.disk.enable (true) already set above in FASTFOX - not duplicated here.
user_pref("dom.timeout.background_throttling_max_budget", 100); // strict CPU budget for background worker scripts
user_pref("media.hardware-video-decoding.failed", false); // default: let Gecko manage HW-decode fallback

/** ZEN UI OVERHEAD ***/
user_pref("zen.view.experimental-rounded-view", false); // disable experimental UI rounding (lag/power draw)
user_pref("zen.theme.content-element-separation", 0); // remove gaps/borders around pages (less layout math)
user_pref("zen.theme.gradient", false); // solid sidebar colors instead of CSS gradients (less GPU redraw)
user_pref("zen.theme.acrylic-elements", false); // WINDOWS: disable resource-heavy Acrylic blur effects

/** NETWORK & PROCESS CONSTRAINTS ***/
user_pref("privacy.trackingprotection.enabled", true); // drop tracker scripts early (saves energy on ad code)
// NOTE: network.predictor.enabled (false) already set above in FASTFOX - not duplicated here.
user_pref("network.http.speculative-parallel-limit", 0); // no pre-connecting/pre-downloading on link hover
user_pref("dom.ipc.processCount", 4); // cap content process pool (use 2 for a more aggressive limit)

/****************************************************************************
 * SECTION: SMOOTHFOX                                                       *
****************************************************************************/
// visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
// Enter your scrolling overrides below this line:

/****************************************************************************
 * END: BETTERFOX                                                           *
****************************************************************************/
