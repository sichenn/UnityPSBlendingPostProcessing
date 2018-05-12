using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace Dawn.PostProcessing
{
    [CustomEditor(typeof(PSBlending))]
    public class PSBlendingEditor : Editor
    {
        private PSBlending psBlending { get { return target as PSBlending; } }

        private void OnEnable()
        {
            psBlending.UpdateProperties();
        }

        public override void OnInspectorGUI()
        {
            EditorGUI.BeginChangeCheck();
            base.OnInspectorGUI();
            if (EditorGUI.EndChangeCheck())
            {
                psBlending.UpdateProperties();
            }
        }
    }

}
