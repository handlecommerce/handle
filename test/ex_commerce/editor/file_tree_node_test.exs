defmodule ExCommerce.Editor.FileTreeNodeTest do
  use ExUnit.Case, async: true
  alias ExCommerce.Editor.FileTreeNode

  describe "new/1" do
    test "create root file node" do
      assert FileTreeNode.new(["index.html"]) == [
               %ExCommerce.Editor.FileTreeNode{
                 type: :file,
                 name: "index.html",
                 expanded: nil,
                 children: nil
               }
             ]
    end

    test "create nested file node" do
      assert FileTreeNode.new(["templates", "index.html"]) ==
               [
                 %ExCommerce.Editor.FileTreeNode{
                   type: :directory,
                   name: "templates",
                   expanded: false,
                   children: [
                     %ExCommerce.Editor.FileTreeNode{
                       type: :file,
                       name: "index.html",
                       expanded: nil,
                       children: nil
                     }
                   ]
                 }
               ]
    end

    test "merges duplicate parent directory nodes" do
      result =
        FileTreeNode.new(["templates", "index.html"])
        |> FileTreeNode.new(["templates", "secondary.html"])

      assert result == [
               %ExCommerce.Editor.FileTreeNode{
                 type: :directory,
                 name: "templates",
                 expanded: false,
                 children: [
                   %ExCommerce.Editor.FileTreeNode{
                     type: :file,
                     name: "index.html",
                     expanded: nil,
                     children: nil
                   },
                   %ExCommerce.Editor.FileTreeNode{
                     type: :file,
                     name: "secondary.html",
                     expanded: nil,
                     children: nil
                   }
                 ]
               }
             ]
    end

    test "replaces existing file" do
      result =
        FileTreeNode.new(["templates", "index.html"])
        |> FileTreeNode.new(["templates", "index.html"])

      assert result == [
               %ExCommerce.Editor.FileTreeNode{
                 type: :directory,
                 name: "templates",
                 expanded: false,
                 children: [
                   %ExCommerce.Editor.FileTreeNode{
                     type: :file,
                     name: "index.html",
                     expanded: nil,
                     children: nil
                   }
                 ]
               }
             ]
    end
  end
end
