module ServerTools

  #
  # Creates the complete path passed and puts a message to the console.
  #
  def create_directory(path)
    puts "Create directory\t#{path}"
    FileUtils.mkpath(path)
  end

  #
  # Deletes a file and puts a message to the console.
  #
  def delete_file(file)
    puts "Delete file/\t#{file}"
    FileUtils.remove(file)
  end

  #
  # Creates a symlink from source to target and puts a message to the console.
  #
  def create_symlink(source, target)
    puts "Create symlink\t\t#{source} -> #{target}"
    FileUtils.symlink(source, target)
  end
  
end