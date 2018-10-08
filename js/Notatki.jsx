import React from "react";
import AddNote from "./AddNote.jsx";
import AddFolder from './AddFolder.jsx';
import EditMode from './EditMode.jsx'
import NotegroupList from './NotegroupList.jsx'

const siteUrl = "http://127.0.0.1:5000"; 

class Notatki extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      currentDepth: 0,
      data: [],
      currentPath: [],
      currentDirId: [],
      editModeOn: false
    };
  }

  componentWillMount() {
    //Download root folders and set state of data[0] to array of folder objects
    const that = this;
    fetch(siteUrl + '/api?query={getToken}')
      .then(response => response.json())
      .then(res => res.data.getToken)
      .then(token => fetch(siteUrl + '/api?query={getRootId(id_usergroup:1,access_token:"' + token + '")}')
        .then(response => response.json())
        .then(myJson => Number(myJson.data.getRootId))
        .then(rootId => {
          that.setState({
            currentDirId: [rootId]
          })
          return fetch(siteUrl+'/api?query={getContent(id_notegroup:' + rootId + ',access_token:"' + token + '")}')
        })
        .then(response => response.json())
        .then(myJson => JSON.parse(myJson.data.getContent))
      )
      .then(function (innerJson) {
        let rootFolders = [];
        for (const notegroup of innerJson) {
          let object = {};
          object["title"] = notegroup.folder_name;
          if (notegroup.idnote) {
            object["key"] = "note" + notegroup.idnote;
          } else {
            object["key"] = notegroup.idnotegroup;
          }
          rootFolders.push(object);
        };
        let updated_data = that.state.data;
        updated_data[0] = rootFolders;
        that.setState({ data: updated_data });
      })
      .catch(error => console.log(error));
  }


  changeCurrentDirectory = e => {
    //Increase depth, set state of data[depth] to downloaded array of folder/note object
    let selected_dir_id = e.target.id;
    let selected_dir_name = e.target.innerText;
    const that = this;
    fetch(siteUrl + '/api?query={getToken}')
      .then(response => response.json())
      .then(res => res.data.getToken)
      .then(token => fetch(siteUrl + '/api?query={getContent(id_notegroup:' + selected_dir_id + ',access_token:"' + token + '")}'))
      .then(response => response.json())
      .then(myJson => JSON.parse(myJson.data.getContent))
      .then(function (innerJson) {
        let folderContent = [];
        for (const notegroup of innerJson) {
          let object = {};
          if (notegroup.idnote) {
            object["title"] = notegroup.name;
            object["key"] = "note" + notegroup.idnote;
            object["is_note"] = true;
          } else {
            object["title"] = notegroup.folder_name;
            object["key"] = notegroup.idnotegroup;
            object["is_note"] = false;
          }
          folderContent.push(object);
        };
        let updated_data = that.state.data;
        updated_data[that.state.currentDepth + 1] = folderContent;
        let updated_path = that.state.currentPath;
        updated_path[that.state.currentDepth] = selected_dir_name;
        let updated_dir_id = that.state.currentDirId;
        updated_dir_id[that.state.currentDepth + 1] = Number(selected_dir_id);
        that.setState(prevState => ({
          data: updated_data,
          currentDepth: prevState.currentDepth + 1,
          currentPath: updated_path,
          currentDirId: updated_dir_id
        }));
      })
      .catch(error => console.log(error));
  };

  openNote = (e) => {
    console.log("Jak wyświetlić notatkę?");

    let id = e.target.id.slice(4);
    window.open(siteUrl + `/download/${id}`);
  }

  prevFolder = () => {
    //Update current path and decrease depth (if 1 or higher)
    let path = this.state.currentPath;
    let depth = this.state.currentDepth;
    path.pop();
    if (!this.state.currentDepth < 1) {
      depth -= 1;
    }
    this.setState({
      currentDepth: depth,
      currentPath: path
    });
  }

  showCurrentPath = () => {
    //Show current path from state
    let path = "";
    for (const folder of this.state.currentPath) {
      path = path + " / " + folder;
    }
    return <h5>{path}</h5>
  }

  packContent = () => {
    //Show content of current depth form state (this.state.data)
    if (this.state.data[this.state.currentDepth]) {
      var content = [];
      for (const value of this.state.data[this.state.currentDepth]) {
        if (value.is_note) {
          content.push(<div><h1 onClick={this.openNote} id={value.key} key={value.key}>
            {"Notatka " + value.title}
          </h1>
            <span onClick={this.deleteNote}>
              {this.state.editModeOn ? " x" : null}
            </span>
          </div>);
        } else {
          content.push(<div><h1 onClick={this.changeCurrentDirectory} id={value.key} key={value.key}>
            {value.title}
          </h1>
            <span onClick={this.deleteFolder}>
              {this.state.editModeOn ? " x " : null}
            </span>
          </div>);
        }
      }
      return content;
    }
    return null;
  };

  uploadNote = (e) => {
    e.preventDefault();
    const form = document.getElementById('form');
    const file = form[1].files[0];
    const title = form[0].value;
    var formData = new FormData();
    formData.append('file', file);
    formData.append('title', title);
    formData.append('notegroup_id', this.state.currentDirId[this.state.currentDepth]);
    fetch(siteUrl + '/add/', {
      method: 'POST',
      body: formData
    }).then(
      response => response.text() // if the response is a JSON object
    ).then(
      success => console.log(success) // Handle the success response object
    ).catch(
      error => console.log(error) // Handle the error response object
    );
  }

  addFolder = (e) => {
    e.preventDefault();
    var formData = new FormData();
    formData.append('title', document.getElementById('addFolderForm')[0].value);
    formData.append('parent_id', this.state.currentDirId[this.state.currentDirId.length - 1]);
    formData.append('class', '3');
    fetch(siteUrl + '/admin/add/', {
      method: 'POST',
      body: formData
    }).then(
      response => response.text() // if the response is a JSON object
    ).then(
      success => console.log(success) // Handle the success response object
    ).catch(
      error => console.log(error) // Handle the error response object
    );
  }

  changeMode = (e) => {
    e.preventDefault();
    this.setState(prevState => ({
      editModeOn: !prevState.editModeOn
    }))
  }
  
  deleteNote = (e) => {
    let note_id = e.target.previousSibling.id.slice(4);
    fetch(siteUrl + '/admin/delete/note/' + note_id, {
    }).then(
      response => response.text() // if the response is a JSON object
    ).then(
      success => console.log(success) // Handle the success response object
    ).catch(
      error => console.log(error) // Handle the error response object
    );
  }

  deleteFolder = (e) => {
    console.log("Jak usunąć folder?")
    console.log(e.target.previousSibling.id);   
  }

  render() {
    return (
      <div>
        <NotegroupList></NotegroupList>
        <AddNote uploadNote={this.uploadNote}></AddNote>
        <AddFolder addFolder={this.addFolder}></AddFolder>
        <EditMode changeMode={this.changeMode} isOn={this.state.editModeOn}></EditMode>
        <h1 onClick={this.prevFolder}>Cofnij</h1>
        {this.showCurrentPath()}
        {this.packContent()}
      </div>
    );
  };
}

export default Notatki;
