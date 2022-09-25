import { assertFails, assertSucceeds } from "@firebase/rules-unit-testing";
import { doc, getDoc, setDoc } from "firebase/firestore";
import { getUserRef, testEnv } from "./helper";

describe("/users", () => {
  it("no access by anonymous users", async () => {
    const anonymous = testEnv.unauthenticatedContext();
    await assertFails(getDoc(doc(anonymous.firestore(), "users", "anonymous")));
  });

  it("authenticated without email verification cannot read", async () => {
    const user = testEnv.authenticatedContext("dieter");
    await assertFails(getDoc(doc(user.firestore(), "users", "dieter")));
  });

  it("authenticated with email verification can read", async () => {
    const { firestore, userId } = getUserRef("jane");
    await assertSucceeds(getDoc(doc(firestore, "users", userId)));
  });

  it("authenticated can write", async () => {
    const { firestore, userId } = getUserRef("jane");
    await assertSucceeds(
      setDoc(doc(firestore, "users", userId), {
        displayName: "test1",
        photoURL: "test2",
        communityCount: 0,
      })
    );
  });

  it("invalid payload fails", async () => {
    const { firestore, userId } = getUserRef("jane");

    // invalid displayName
    await assertFails(
      setDoc(doc(firestore, "users", userId), {
        displayName: "",
        photoURL: "test2",
        communityCount: 0,
      })
    );
    // invalid photoURL
    await assertFails(
      setDoc(doc(firestore, "users", userId), {
        displayName: "test1",
        photoURL: "",
        communityCount: 0,
      })
    );
  });
});
