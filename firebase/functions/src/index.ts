import {registUser} from "./regist_user";
import {createNewMessage} from "./create_new_message";
import {createLoginToken} from "./create_login_token";

import * as admin from "firebase-admin";

admin.initializeApp();

exports.registUser = registUser;
exports.createLoginToken = createLoginToken;
exports.createNewMessage = createNewMessage;
