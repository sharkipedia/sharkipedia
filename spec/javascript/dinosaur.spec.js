import Dinosaur from "Dinosaur";
test("Dinosaurs are extinct", () => {
	expect(new Dinosaur().isExtinct).toBeTruthy();
});
