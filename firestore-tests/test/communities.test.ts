import { assertFails, assertSucceeds } from "@firebase/rules-unit-testing";
import { doc, getDoc, setDoc } from "firebase/firestore";
import { createUserRecord, getUserRef, testEnv } from "./helper";

describe("/communities", () => {
  it("unauthenticated user cannot read", async () => {
    const anonymous = testEnv.unauthenticatedContext();
    await assertFails(getDoc(doc(anonymous.firestore(), "communities", "1")));
  });

  it("authenticated user can read", async () => {
    const { firestore } = getUserRef("jane");
    await assertFails(getDoc(doc(firestore, "communities", "1")));
  });
});

describe("/communities with registered users", () => {
  it("registered user can create community including private data", async () => {
    const { firestore, userId } = getUserRef("jane");
    createUserRecord("jane");

    await assertSucceeds(setDoc(doc(firestore, "communities", "1"), {}));
    await assertSucceeds(
      setDoc(doc(firestore, "communities/1/private_data", "private"), {})
    );
  });

  it("registered user can read community private data", async () => {
    const { firestore, userId } = getUserRef("jane");
    createUserRecord("jane");
    await assertSucceeds(setDoc(doc(firestore, "communities", "1"), {}));
    await assertSucceeds(
      setDoc(doc(firestore, "communities/1/private_data", "private"), {})
    );

    await assertSucceeds(
      getDoc(doc(firestore, "communities/1/private_data", "private"))
    );
  });
});
