import {
  initializeTestEnvironment,
  RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { doc, getDoc, setDoc } from "firebase/firestore";
import * as fs from "fs";
import firebase from "firebase/compat/app";

export let testEnv: RulesTestEnvironment;

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: "demo-project-1234",
    firestore: {
      rules: fs.readFileSync("../firestore.rules", "utf8"),
      host: "localhost",
      port: 8080,
    },
  });
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

afterEach(async () => {
  await testEnv.clearFirestore();
});

export type UserRef = {
  firestore: firebase.firestore.Firestore;
  userId: string;
};

export type User = "jane" | "joe";

export function getUserRef(user: User): UserRef {
  return {
    firestore: testEnv
      .authenticatedContext(user, {
        email_verified: true,
      })
      .firestore(),
    userId: user,
  };
}

/**
 * Creates a user record that fulfills the prerequisites.
 * @param user the user
 */
export function createUserRecord(user: User) {
  const { firestore, userId } = getUserRef(user);
  setDoc(doc(firestore, "users", userId), {
    displayName: user,
    photoURL: "test2",
    communityCount: 0,
  });
}
