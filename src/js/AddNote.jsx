import React from "react";

const AddNote = (props) => {
  return (
    <form id="form" onSubmit={props.uploadNote}>
      <span>Dodaj notatkę w aktualnym folderze</span>
      <input required type="text" name="title"></input>
      <input required id="file" type="file" name="file"></input>
      <input type="submit"></input>
    </form>
  )
};


export default AddNote;