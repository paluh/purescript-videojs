/* global exports */
"use strict";

// module Snc

var converse = require('converse');

exports.initChatImpl = function(prebindUrl, boshServiceUrl, room, jid, nick) {
  //videoChat.initializeChat(prebind_url, bosh_service_url, room, jid, nick);
  return function() {
      converse.initialize({
          allow_contact_requests: false, // Contacts from other servers cannot, // be added and anonymous users don't // know one another's JIDs, so disabling.
          allow_dragresize: true,
          allow_logout: true, // No point in logging out when we have auto_login as true.
          allow_muc_invitations: false, // Doesn't make sense to allow because only // roster contacts can be invited
          allow_registration: false,
          authentication: 'prebind',
          auto_join_rooms: [ {'jid': room, 'nick': nick} ],
          auto_list_rooms: false,
          auto_login: true,
          bosh_service_url: boshServiceUrl,
          debug: true,
          hide_muc_server: true, // Federation is disabled, so no use in // showing the MUC server.
          hide_offline_users: true,
          jid: jid,
          keepalive: true,
          muc_instant_rooms: true,
          notify_all_room_messages: [ room ],
          play_sounds: false,
          prebind_url: prebindUrl,
          show_controlbox_by_default: true,
          strict_plugin_dependencies: false,
      });
  };
};
