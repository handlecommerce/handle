import * as monaco from 'monaco-editor';
import { ILiveViewHook } from './hook';

// Since packaging is done by you, you need
// to instruct the editor how you named the
// bundles that contain the web workers.
self.MonacoEnvironment = {
  getWorkerUrl: function (moduleId, label) {
    // if (label === 'json') {
    //   return './json.worker.bundle.js';
    // }
    // if (label === 'css' || label === 'scss' || label === 'less') {
    //   return './css.worker.bundle.js';
    // }
    if (label === 'html' || label === 'handlebars' || label === 'razor') {
      return '/assets/node_modules/monaco-editor/esm/vs/language/html/html.worker.js';
    }
    // if (label === 'typescript' || label === 'javascript') {
    //   return './ts.worker.bundle.js';
    // }

    return "/assets/node_modules/monaco-editor/esm/vs/editor/editor.worker.js"
  }
};

interface IMonacoEditor extends ILiveViewHook {
  save(): void | Promise<void>;
  syncElement: HTMLInputElement;
  editor: monaco.editor.IStandaloneCodeEditor;
}

const MonacoEditor = {
  mounted(this: IMonacoEditor) {
    this.syncElement = document.getElementById(this.el.dataset['editorField']!) as HTMLInputElement;

    this.editor = monaco.editor.create(this.el, {
      language: 'html',
      scrollBeyondLastLine: false,
      automaticLayout: true,
      value: this.el.dataset['editorValue'],
    });

    // Add a save action with CMD/CTRL-S
    this.editor.addAction({
      id: "Save Asset",
      label: "Save Asset",
      keybindings: [
        // tslint:disable-next-line: no-bitwise
        monaco.KeyMod.CtrlCmd | monaco.KeyCode.KeyS
      ],

      run: () => this.save()
    });

    this.editor.getModel()?.onDidChangeContent(() => {
      this.syncElement.value = this.editor.getValue();
    });
    window.addEventListener("resize", () => this.editor.layout());
  },

  save(this: IMonacoEditor) {

  }
}

export { MonacoEditor }
