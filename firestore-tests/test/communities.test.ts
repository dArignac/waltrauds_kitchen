import { assertFails, assertSucceeds } from "@firebase/rules-unit-testing";
import { doc, getDoc, setDoc } from "firebase/firestore";
import { resolveTripleslashReference } from "typescript";
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
  it("registered user cannot create communities/1 with invalid payload", async () => {
    const { firestore } = getUserRef("jane");
    createUserRecord("jane");

    await assertFails(setDoc(doc(firestore, "communities", "1"), {}));
  });

  it("registered user cannot create communities/1/private_data/private with invalid payload", async () => {
    const { firestore } = getUserRef("jane");
    createUserRecord("jane");
    await assertSucceeds(
      setDoc(doc(firestore, "communities", "1"), { name: "C1" })
    );

    await assertFails(
      setDoc(doc(firestore, "communities/1/private_data", "private"), {})
    );

    await assertFails(
      setDoc(doc(firestore, "communities/1/private_data", "private"), {
        roles: { jane: "goddess" },
      })
    );
  });

  it("registered user can create community including private data", async () => {
    // setup
    const { firestore } = getUserRef("jane");
    createUserRecord("jane");

    // tests
    await assertSucceeds(
      setDoc(doc(firestore, "communities", "1"), { name: "C1" })
    );
    await assertSucceeds(
      setDoc(doc(firestore, "communities/1/private_data", "private"), {
        roles: { jane: "owner" },
      })
    );
  });

  it("registered user can read community private data", async () => {
    // setup
    const { firestore } = getUserRef("jane");
    createUserRecord("jane");
    await assertSucceeds(
      setDoc(doc(firestore, "communities", "1"), {
        name: "C1",
      })
    );
    await assertSucceeds(
      setDoc(doc(firestore, "communities/1/private_data", "private"), {
        roles: { jane: "owner" },
      })
    );

    // tests
    await assertSucceeds(
      getDoc(doc(firestore, "communities/1/private_data", "private"))
    );
  });
});
