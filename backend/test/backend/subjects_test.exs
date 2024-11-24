defmodule Backend.SubjectsTest do
  use Backend.DataCase

  alias Backend.Subjects

  describe "subjects" do
    alias Backend.Subjects.Subject

    alias Backend.Accounts.Account

    alias Backend.Groups.Group

    import Backend.GroupsFixtures

    import Backend.AccountsFixtures

    import Backend.SubjectsFixtures

    @invalid_attrs %{
      description: nil,
      title: nil,
      short_title: nil,
      prerequisites: nil,
      objectives: nil,
      required_texts: nil
    }

    test "list_subjects/0 returns all subjects" do
      subject = subject_fixture()
      {:ok, %{list: list}} = Subjects.list_subjects()
      assert Enum.map(list, fn s -> %{s | teachers: []} end) == [subject]
    end

    test "get_subject!/1 returns the subject with given id" do
      subject = subject_fixture()
      assert Subjects.get_subject!(subject.id) == subject
    end

    test "create_subject/1 with valid data creates a subject" do
      valid_attrs = %{
        description: "some description",
        title: "some title",
        short_title: "some short_title",
        prerequisites: "some prerequisites",
        objectives: "some objectives",
        required_texts: "some required_texts"
      }

      assert {:ok, %Subject{} = subject} = Subjects.create_subject(valid_attrs)
      assert subject.description == "some description"
      assert subject.title == "some title"
      assert subject.short_title == "some short_title"
      assert subject.prerequisites == "some prerequisites"
      assert subject.objectives == "some objectives"
      assert subject.required_texts == "some required_texts"
    end

    test "create_subject/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subjects.create_subject(@invalid_attrs)
    end

    test "update_subject/2 with valid data updates the subject" do
      subject = subject_fixture()

      update_attrs = %{
        description: "some updated description",
        title: "some updated title",
        short_title: "some updated short_title",
        prerequisites: "some updated prerequisites",
        objectives: "some updated objectives",
        required_texts: "some updated required_texts"
      }

      assert {:ok, %Subject{} = subject} = Subjects.update_subject(subject, update_attrs)
      assert subject.description == "some updated description"
      assert subject.title == "some updated title"
      assert subject.short_title == "some updated short_title"
      assert subject.prerequisites == "some updated prerequisites"
      assert subject.objectives == "some updated objectives"
      assert subject.required_texts == "some updated required_texts"
    end

    test "update_subject/2 with invalid data returns error changeset" do
      subject = subject_fixture()
      assert {:error, %Ecto.Changeset{}} = Subjects.update_subject(subject, @invalid_attrs)
      assert subject == Subjects.get_subject!(subject.id)
    end

    test "delete_subject/1 deletes the subject" do
      subject = subject_fixture()
      assert {:ok, %Subject{}} = Subjects.delete_subject(subject)
      assert_raise Ecto.NoResultsError, fn -> Subjects.get_subject!(subject.id) end
    end

    test "change_subject/1 returns a subject changeset" do
      subject = subject_fixture()
      assert %Ecto.Changeset{} = Subjects.change_subject(subject)
    end

    test "link_subject_with_teacher_and_group/1 returns correct taught subject entity" do
      subject_id = subject_fixture().id
      teacher_id = account_fixture(%{roles: [:teacher]}).id
      group_id = group_fixture().id

      assert {:ok, %{subject_id: ^subject_id, taught_by_id: ^teacher_id, group_id: ^group_id}} =
               Subjects.link_subject_with_teacher_and_group(%{
                 subject_id: subject_id,
                 taught_by_id: teacher_id,
                 group_id: group_id
               })
    end

    test "link_subject_with_teacher_and_group/1 fails with wrong group_id" do
      subject_id = subject_fixture().id
      teacher_id = account_fixture(%{roles: [:teacher]}).id
      group_id = group_fixture().id

      assert {:error, %Ecto.Changeset{}} =
               Subjects.link_subject_with_teacher_and_group(%{
                 subject_id: subject_id,
                 taught_by_id: teacher_id,
                 group_id: group_id + 1
               })
    end

    test "link_subject_with_teacher_and_group/1 fails with wrong teacher_id" do
      subject_id = subject_fixture().id
      teacher_id = account_fixture(%{roles: [:teacher]}).id
      group_id = group_fixture().id

      assert {:error, %Ecto.Changeset{}} =
               Subjects.link_subject_with_teacher_and_group(%{
                 subject_id: subject_id,
                 taught_by_id: teacher_id + 1,
                 group_id: group_id
               })
    end

    test "link_subject_with_teacher_and_group/1 fails with wrong subject_id" do
      subject_id = subject_fixture().id
      teacher_id = account_fixture(%{roles: [:teacher]}).id
      group_id = group_fixture().id

      assert {:error, %Ecto.Changeset{}} =
               Subjects.link_subject_with_teacher_and_group(%{
                 subject_id: subject_id + 1,
                 taught_by_id: teacher_id,
                 group_id: group_id
               })
    end
  end
end
